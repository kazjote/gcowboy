using Gtk;

public class WindowBootstrap : Object
{
    public InfoBar infobar { private set; public get; }
    public Models.TaskRepository task_repository { private set; public get; }
    public Views.NotificationAreaView notification_area_view { private set; public get; }
    public Views.NewTaskView new_task_view { private set; public get; }
    public Views.TaskListsView task_lists_view { private set; public get; }
    public Controllers.SearchController search_controller { private set; public get; }

    private RtmWrapper rtm;
    private MainLoop loop;
    private AsyncQueue<QueueMessage> response_queue;

    public WindowBootstrap (MainLoop _loop)
    {
        loop = _loop;
    }

    public void bootstrap ()
    {
        setup_rtm ();
        setup_interface ();
        setup_rtm_events ();
    }

    private void setup_interface ()
    {
        try
        {
            var builder = new Builder ();
            builder.add_from_file (Config.GCOWBOY_UI_FILE);

            var window = builder.get_object ("window") as Window;

            window.set_events (Gdk.EventType.ENTER_NOTIFY);
            window.destroy.connect(() => {
                loop.quit ();
                Gtk.main_quit();
            });

            var screen = Gdk.Screen.get_default ();
            var css_provider = new CssProvider();
            css_provider.load_from_file (File.new_for_path (Config.GCOWBOY_CSS_FILE));

            Gtk.StyleContext.add_provider_for_screen (screen, css_provider, STYLE_PROVIDER_PRIORITY_APPLICATION);

            var list_view = builder.get_object ("list_view") as TreeView;

            var cell = new Gtk.CellRendererText ();
            list_view.insert_column_with_attributes (-1, "Lists", cell, "text", 0);

            infobar = builder.get_object ("infobar") as InfoBar;

            var notification_bar = builder.get_object ("NotificationBar") as InfoBar;
            notification_area_view = new Views.NotificationAreaView (notification_bar);

            var task_box = builder.get_object ("task_box") as Box;
            task_repository = new Models.TaskRepository (rtm);

            var task_lists_model = new Models.TaskListsModel (task_repository, rtm);

            task_lists_view = new Views.TaskListsView (task_lists_model, list_view, task_box, notification_area_view);
            task_lists_model.fetch ();

            var new_task_entry = builder.get_object ("NewTaskEntry") as Entry;
            new_task_view = new Views.NewTaskView (new_task_entry, task_repository, notification_area_view);

            var search_entry = builder.get_object ("SearchEntry") as Entry;
            search_controller = new Controllers.SearchController (search_entry, task_repository, rtm, task_lists_model, task_lists_view);

            window.show ();

            infobar.hide ();
        }
        catch (Error e) {
            stderr.printf ("Could not load UI: %s\n", e.message);
        }
    }

    private string token_file_path ()
    {
        return Environment.get_home_dir () + "/.gcowboy_token";
    }

    private void setup_rtm ()
    {
        response_queue = new AsyncQueue<QueueMessage> ();

        rtm = new RtmWrapper (response_queue);

        try {

            var file = File.new_for_path (token_file_path ());

            if (file.query_exists ()) {
                var dis = new DataInputStream (file.read ());
                var token = dis.read_line ();
                rtm.set_token (token);
            }
        } catch (Error e) {
            stderr.printf ("Can't load token for a file %s\n", e.message);
        }

    }

    private void setup_rtm_events ()
    {
        rtm.authorization.connect((t, url) => {
            infobar.add_button ("Authorize", 1);

            Container content = infobar.get_content_area ();
            content.add (new Gtk.Label ("Authorization needed."));

            infobar.show_all ();

            infobar.response.connect ((id) => {
                try {
                    AppInfo.launch_default_for_uri (url, null);
                } catch (Error e) {
                    stderr.printf ("Can't run browser!");
                }
            });
        });

        rtm.authenticated.connect((t, token) => {
            infobar.hide ();

            try {
                var file = File.new_for_path (token_file_path ());

                if (file.query_exists ()) file.delete ();

                var dos = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));

                dos.put_string (token);
            } catch (Error e) {
                stderr.printf ("Can't save token to a file\n");
            }

        });

        TimeoutSource time = new TimeoutSource (200);

        time.set_callback (() => {
            var queue_message = response_queue.try_pop ();

            if (queue_message != null) {
                queue_message.callback (queue_message);
            }
            return true;
        });

        time.attach (loop.get_context ());
    }
}

// vim: ts=4 sw=4
