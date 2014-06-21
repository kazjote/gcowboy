public class DBusBootstrap : Object
{

    public signal void name_aquired ();
    public signal void name_exists ();

    public DBusBootstrap ()
    {
    }

    void on_bus_aquired (DBusConnection conn)
    {
        try {
            conn.register_object ("/eu/kazjote/GCowboy", new DBusServer ());
        } catch (IOError e) {
            stderr.printf ("Could not register service\n");
        }
    }

    public void bootstrap ()
    {
        Bus.own_name (BusType.SESSION, "eu.kazjote.GCowboy", BusNameOwnerFlags.NONE,
              on_bus_aquired,
              () => name_aquired (),
              () => name_exists ());
    }

}

// vim: ts=4 sw=4
