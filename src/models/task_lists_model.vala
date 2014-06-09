namespace Models
{
    public class TaskListsModel : Object, Gtk.TreeModel
    {
        private List<TaskListInterface> task_lists;
        private RtmWrapper rtm { get; set; }
        private TaskRepository repository { get; set; }
        private int stamp = 0;

        public signal void list_updated ();

        public TaskListsModel (TaskRepository repo, RtmWrapper _rtm)
        {
            repository = repo;
            rtm = _rtm;
        }

        public TaskListInterface get_task_list(int i)
        {
            return task_lists.nth_data (i);
        }

        public List<TaskListInterface> get_task_lists ()
        {
            return task_lists.copy ();
        }

        public void fetch ()
        {
            rtm.get_lists ((message) => {
                message.rtm_response.task_lists.foreach ((task_list) => {
                    if (task_list.smart == false) {
                        task_lists.append (new StandardTaskListModel (repository, rtm, task_list));
                    } else {
                        task_lists.append (new SmartTaskListModel (repository, rtm, task_list));
                    }

                    notify_addition ();
                });

                list_updated ();
            });
        }

        public Gtk.TreePath add_task_list (TaskListInterface task_list)
        {
            task_lists.append (task_list);

            var tree_path = notify_addition ();
            list_updated ();

            return tree_path;
        }

        private Gtk.TreePath notify_addition ()
        {
            stamp++;

            var iter = Gtk.TreeIter ();
            iter.stamp = stamp;
            iter.user_data = (task_lists.length () - 1).to_pointer ();

            var tree_path = get_path (iter);

            row_inserted (tree_path, iter);

            return tree_path;
        }

        // From documentation

        public Type get_column_type (int index) {
            switch (index) {
            case 0:
                return typeof (string);
            default:
                return Type.INVALID;
            }
        }

        public Gtk.TreeModelFlags get_flags () {
            return 0;
        }

        public void get_value (Gtk.TreeIter iter, int column, out Value val) {
            assert (iter.stamp == stamp);

            TaskListInterface task_list_interface = task_lists.nth_data ((int) iter.user_data);
            switch (column) {
            case 0:
                val = Value (typeof (string));
                val.set_string (task_list_interface.name);
                break;
            default:
                val = Value (Type.INVALID);
                break;
            }
        }

        public bool get_iter (out Gtk.TreeIter iter, Gtk.TreePath path) {
            if (path.get_depth () != 1 || task_lists.length () == 0) {
                return invalid_iter (out iter);
            }

            iter = Gtk.TreeIter ();
            iter.user_data = path.get_indices ()[0].to_pointer ();
            iter.stamp = this.stamp;
            return true;
        }

        public int get_n_columns () {
            // id, name, price, stock
            return 1;
        }

        public Gtk.TreePath? get_path (Gtk.TreeIter iter) {
            assert (iter.stamp == stamp);

            Gtk.TreePath path = new Gtk.TreePath ();
            path.append_index ((int) iter.user_data);
            return path;
        }

        public int iter_n_children (Gtk.TreeIter? iter) {
            assert (iter == null || iter.stamp == stamp);
            return (int)((iter == null) ? task_lists.length () : 0);
        }

        public bool iter_next (ref Gtk.TreeIter iter) {
            assert (iter.stamp == stamp);

            int pos = ((int) iter.user_data) + 1;
            if (pos >= task_lists.length ()) {
                return false;
            }
            iter.user_data = pos.to_pointer ();
            return true;
        }

        public bool iter_previous (ref Gtk.TreeIter iter) {
            assert (iter.stamp == stamp);

            int pos = (int) iter.user_data;
            if (pos >= 0) {
                return false;
            }

            iter.user_data = (--pos).to_pointer ();
            return true;
        }

        public bool iter_nth_child (out Gtk.TreeIter iter, Gtk.TreeIter? parent, int n) {
            assert (parent == null || parent.stamp == stamp);

            if (parent == null && n < task_lists.length ()) {
                iter = Gtk.TreeIter ();
                iter.stamp = stamp;
                iter.user_data = n.to_pointer ();
                return true;
            }

            // Only used for trees
            return invalid_iter (out iter);
        }

        public bool iter_children (out Gtk.TreeIter iter, Gtk.TreeIter? parent) {
            assert (parent == null || parent.stamp == stamp);
            // Only used for trees
            return invalid_iter (out iter);
        }

        public bool iter_has_child (Gtk.TreeIter iter) {
            assert (iter.stamp == stamp);
            // Only used for trees
            return false;
        }

        public bool iter_parent (out Gtk.TreeIter iter, Gtk.TreeIter child) {
            assert (child.stamp == stamp);
            // Only used for trees
            return invalid_iter (out iter);
        }

        private bool invalid_iter (out Gtk.TreeIter iter)
        {
            iter = Gtk.TreeIter ();
            iter.stamp = -1;
            return false;
        }
    }
}

// vim: ts=4 sw=4
