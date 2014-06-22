[DBus (name = "eu.kazjote.GCowboy")]
public interface DBusServerInterface : Object {
    public abstract void open () throws IOError;
}

[DBus (name = "eu.kazjote.GCowboy")]
public class DBusServer : Object {

    public signal void opened ();

    public void open () {
        stdout.puts("Open signal\n");
        opened ();
    }
}

// vim: ts=4 sw=4
