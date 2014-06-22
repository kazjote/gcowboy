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

using Gtk;

public class Main : Object
{
    public MainLoop loop;

    public WindowBootstrap window_bootstrap { private set; public get; }
    public DBusBootstrap dbus_bootstrap { private set; public get; }

    public Main ()
    {
        loop = new MainLoop ();

        dbus_bootstrap = new DBusBootstrap ();

        dbus_bootstrap.name_aquired.connect (() => {
            window_bootstrap = new WindowBootstrap (loop);
            window_bootstrap.bootstrap ();
        });

        dbus_bootstrap.opened.connect (() => {
            window_bootstrap.show_window ();
        });

        dbus_bootstrap.name_exists.connect (() => {
            loop.quit ();
            Gtk.main_quit();
        });

        dbus_bootstrap.bootstrap ();
    }

    static int main (string[] args) 
    {
        Gtk.init (ref args);

        var app = new Main ();

        app.loop.run ();

        return 0;
    }
}

// vim: ts=4 sw=4
