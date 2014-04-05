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

    /* 
     * Uncomment this line when you are done testing and building a tarball
     * or installing
     */
    //const string UI_FILE = Config.PACKAGE_DATA_DIR + "/ui/" + "gcowboy.ui";
    const string UI_FILE = "src/gcowboy.ui";

    /* ANJUTA: Widgets declaration for gcowboy.ui - DO NOT REMOVE */


    public Main ()
    {

        try
        {
            var builder = new Builder ();
            builder.add_from_file (UI_FILE);
            builder.connect_signals (this);

            var window = builder.get_object ("window") as Window;
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
    public void main_destroy (Widget window) 
    {
        Gtk.main_quit();
    }

    static int main (string[] args) 
    {
        Gtk.init (ref args);
        var app = new Main ();

        var rtm_postbacks = new AsyncQueue<RtmPostback> ();

        var rtm = new RtmWrapper (rtm_postbacks);


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
            response.task_lists.foreach((task_list) => {
                var name = task_list.name;
                stdout.printf (@"List: $name\n");
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
