/*
 * Copyright (C) 2014 Kacper Bielecki <kazjote@gmail.com>
 * 
 * GCowboy is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * GCowboy is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using GLib;
using Gtk;


public class Main : Object
{

    private InfoBar infobar;
    private Models.TaskRepository task_repository;
    private Views.TaskList task_list;
    private Views.NotificationArea notification_area;
    private Views.NewTask new_task;
    private Views.TaskListList task_list_list;

    public MainLoop loop; // TODO: Refactor

    /* 
     * Uncomment this line when you are done testing and building a tarball
     * or installing
     */
    //const string UI_FILE = Config.PACKAGE_DATA_DIR + "/ui/" + "gcowboy.ui";
    const string UI_FILE = "src/gcowboy.ui";
	const string CSS_FILE = "src/gcowboy.css";

    public Main (RtmWrapper rtm)
    {
        try
        {
            var builder = new Builder ();
            builder.add_from_file (UI_FILE);

            var window = builder.get_object ("window") as Window;

            window.set_events (Gdk.EventType.ENTER_NOTIFY);
            window.destroy.connect(() => {
                loop.quit ();
                Gtk.main_quit();
            });

            var screen = Gdk.Screen.get_default ();
            var css_provider = new CssProvider(); 
            css_provider.load_from_file (File.new_for_path (CSS_FILE));

            Gtk.StyleContext.add_provider_for_screen (screen, css_provider, STYLE_PROVIDER_PRIORITY_APPLICATION);

            var list_view = builder.get_object ("list_view") as TreeView;

            var cell = new Gtk.CellRendererText ();
            list_view.insert_column_with_attributes (-1, "Lists", cell, "text", 0);

            infobar = builder.get_object ("infobar") as InfoBar;

            var notification_bar = builder.get_object ("NotificationBar") as InfoBar;
            notification_area = new Views.NotificationArea (notification_bar);

            var task_box = builder.get_object ("task_box") as Box;
            task_repository = new Models.TaskRepository (rtm);

            Box task_list_list_box = builder.get_object ("task_list_box") as Box;
            var task_list_list_model = new Models.TaskListList (task_repository, rtm);

            task_list_list = new Views.TaskListList (task_list_list_model, list_view, task_box, notification_area);
            task_list_list_model.fetch ();

            var new_task_entry = builder.get_object ("NewTaskEntry") as Entry;
            new_task = new Views.NewTask (new_task_entry, task_repository, notification_area);

            window.show ();

            infobar.hide ();
        } 
        catch (Error e) {
            stderr.printf ("Could not load UI: %s\n", e.message);
        } 

    }

    static int main (string[] args) 
    {
        Gtk.init (ref args);

        var response_queue = new AsyncQueue<QueueMessage> ();

        var rtm = new RtmWrapper (response_queue);

        var token_file_path = Environment.get_home_dir () + "/.gcowboy_token";

        try {

            var file = File.new_for_path (token_file_path);

            if (file.query_exists ()) {
                var dis = new DataInputStream (file.read ());
                var token = dis.read_line ();
                rtm.set_token (token);
            }
        } catch (Error e) {
            stderr.printf ("Can't load token for a file %s\n", e.message);
        }

        var app = new Main (rtm);

        rtm.authorization.connect((t, url) => {
            app.infobar.add_button ("Authorize", 1);

            Container content = app.infobar.get_content_area ();
            content.add (new Gtk.Label ("Authorization needed."));

            app.infobar.show_all ();

            app.infobar.response.connect ((id) => {
                try {
                    AppInfo.launch_default_for_uri (url, null);
                } catch (Error e) {
                    stderr.printf ("Can't run browser!");
                }
            });
        });

        rtm.authenticated.connect((t, token) => {
            app.infobar.hide ();

            try {
                var file = File.new_for_path (token_file_path);

                if (file.query_exists ()) file.delete ();

                var dos = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));

                dos.put_string (token);
            } catch (Error e) {
                stderr.printf ("Can't save token to a file\n");
            }

        });

        app.loop = new MainLoop ();
        TimeoutSource time = new TimeoutSource (200);

        time.set_callback (() => {
            var queue_message = response_queue.try_pop ();

            if (queue_message != null) {
                queue_message.callback (queue_message);
            }
            return true;
        });

        time.attach (app.loop.get_context ());

        app.loop.run ();

        return 0;
    }
}

// vim: ts=4 sw=4
