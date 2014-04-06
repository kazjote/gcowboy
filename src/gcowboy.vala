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
    private ListStore list_store;
    private ListStore task_store;

    /* 
     * Uncomment this line when you are done testing and building a tarball
     * or installing
     */
    //const string UI_FILE = Config.PACKAGE_DATA_DIR + "/ui/" + "gcowboy.ui";
    const string UI_FILE = "src/gcowboy.ui";

    /* ANJUTA: Widgets declaration for gcowboy.ui - DO NOT REMOVE */


    public Main (RtmWrapper rtm)
    {

        try
        {
            var builder = new Builder ();
            builder.add_from_file (UI_FILE);
            builder.connect_signals (this);

            var window = builder.get_object ("window") as Window;

            var list_view = builder.get_object ("list_view") as TreeView;
            list_store = new ListStore (2, typeof (string), typeof (Rtm.TaskList));
            list_view.set_model (list_store);

            var task_view = builder.get_object ("task_view") as TreeView;
            task_store = new ListStore (3, typeof (string), typeof (Rtm.TaskSerie), typeof (Rtm.Task));
            task_view.set_model (task_store);

            var cell = new Gtk.CellRendererText ();
            list_view.insert_column_with_attributes (-1, "Lists", cell, "text", 0);
            task_view.insert_column_with_attributes (-1, "Tasks", cell, "text", 0);

            list_view.row_activated.connect ((path, column) => {
                TreeIter iter;
                list_store.get_iter (out iter, path);
                Value val;
                list_store.get_value (iter, 1, out val);
                Rtm.TaskList task_list = val.get_object () as Rtm.TaskList;

                rtm.get_task_series (task_list.id, "status:incomplete", (response) => {
                    task_store.clear ();

                    response.task_series.foreach ((task_serie) => {
                        task_serie.tasks.foreach ((task) => {
                            TreeIter task_store_iter;

                            task_store.append (out task_store_iter);
                            task_store.set (task_store_iter, 0, task_serie.name, 1, task_serie, 2, task);
                        });
                    });
                });
            });

            infobar = builder.get_object ("infobar") as InfoBar;
            /* ANJUTA: Widgets initialization for gcowboy.ui - DO NOT REMOVE */
            window.show_all ();

            infobar.hide ();
        } 
        catch (Error e) {
            stderr.printf ("Could not load UI: %s\n", e.message);
        } 

    }

    [CCode (instance_pos = -1)]
    public void main_on_destroy (Widget window)
    {
        Gtk.main_quit();
    }

    static int main (string[] args) 
    {
        Gtk.init (ref args);

        var rtm_postbacks = new AsyncQueue<RtmPostback> ();

        var rtm = new RtmWrapper (rtm_postbacks);

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
        });

        rtm.get_lists ((response) => {
            // app.list_store.clear ();

            response.task_lists.foreach((task_list) => {
                TreeIter iter;
                app.list_store.append (out iter);
                app.list_store.set (iter, 0, task_list.name, 1, task_list);
            });
        });

        MainLoop loop = new MainLoop ();
        TimeoutSource time = new TimeoutSource (200);

        time.set_callback (() => {
            var postback = rtm_postbacks.try_pop ();

            if (postback != null) {
                postback.postback ();
            }
            return true;
        });

        time.attach (loop.get_context ());

        loop.run ();

        return 0;
    }
}

// vim: ts=4 sw=4
