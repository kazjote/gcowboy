using Gtk;

namespace Views
{
    class NewTaskView : Object
    {
        private Entry entry { get; set; }
        private NotificationAreaView notification_area_view { get; set; }
        private Models.TaskRepository repository { get; set; }

        public NewTaskView (Entry _entry, Models.TaskRepository _repository, NotificationAreaView _notification_area_view)
        {
            entry = _entry;
            notification_area_view = _notification_area_view;
            repository = _repository;

            repository.finished_adding.connect (() => {
                var text = shorten (entry.text, 40);
                notification_area_view.set_notification (@"Task '$text' has been added");
                entry.sensitive = true;
                entry.text = "";
            });

            entry.activate.connect (() => {
                entry.sensitive = false;
                repository.add_task (entry.text);
            });
        }

        private string shorten (string caption, int max_length) {
            if (caption.length > max_length) {
                return caption.substring(0, max_length - 3) + "...";
            } else {
                return caption;
            }
        }
    }
}

// vim: ts=4 sw=4
