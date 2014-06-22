public class DBusBootstrap : Object
{

    private DBusServer dbus_server { set; get; }
    private DBusServerInterface dbus_server_interface { set; get; }

    public signal void name_aquired ();
    public signal void name_exists ();
    public signal void opened ();

    public DBusBootstrap ()
    {
    }

    void on_bus_aquired (DBusConnection conn)
    {
        try {
            var dbus_server = new DBusServer ();
            dbus_server.opened.connect (() => {
                opened ();
            });
            conn.register_object ("/eu/kazjote/GCowboy", dbus_server);
        } catch (IOError e) {
            stderr.printf ("Could not register service\n");
        }
    }

    void open_with_dbus ()
    {
        try {
            dbus_server_interface = Bus.get_proxy_sync (BusType.SESSION, "eu.kazjote.GCowboy", "/eu/kazjote/GCowboy");
            dbus_server_interface.open ();
        } catch (IOError e) {
            stderr.printf ("Failed to open with dbus: %s\n", e.message);
        }

        name_exists ();
    }

    public void bootstrap ()
    {
        Bus.own_name (BusType.SESSION, "eu.kazjote.GCowboy", BusNameOwnerFlags.NONE,
              on_bus_aquired,
              () => name_aquired (),
              open_with_dbus);
    }

}

// vim: ts=4 sw=4
