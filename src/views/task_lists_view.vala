using Gtk;

namespace Views
{
    public class TaskListsView : Object
    {
        private Models.TaskListsModel model { get; set; }
        private TreeView list_view { get; private set; }
        private Box task_list_box { get; set; }
        private NotificationAreaView notification_area_view { get; set; }
        private TaskList task_list_view { get; set; }

        public TaskListsView (Models.TaskListsModel task_lists_model,
                TreeView _list_view,
                Box _task_list_box,
                NotificationAreaView _notification_area_view)
        {
            model = task_lists_model;
            list_view = _list_view;
            task_list_box = _task_list_box;
            notification_area_view = _notification_area_view;

            list_view.set_model (model);

            list_view.row_activated.connect ((path, column) => {
                var index = path.get_indices ()[0];
                var task_list = model.get_task_list (index);

                if (task_list_view != null) task_list_view.remove ();
                task_list_view = new Views.TaskList (task_list.id, task_list.repository, task_list_box, notification_area_view);
                task_list_view.draw ();

                task_list.repository.fetch_task_list (task_list.id);
            });
        }
    }
}

// vim: ts=4 sw=4
