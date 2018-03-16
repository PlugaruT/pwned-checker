public class PwnedChecker : Gtk.Application {
    public PwnedChecker () {
        Object (application_id: "com.github.plugarut.pwned-checker",
        flags: ApplicationFlags.FLAGS_NONE);
    }


    protected override void activate () {
        var app_window = new MainWindow (this);
        app_window.show_all ();

        var quit_action = new SimpleAction ("quit", null);

        add_action (quit_action);
        add_accelerator ("Escape", "app.quit", null);

        quit_action.activate.connect (() => {
            if (app_window != null) {
                app_window.destroy ();
            }
        });
    }


    private static int main (string[] args) {
        Gtk.init (ref args);

        var app = new PwnedChecker ();
        return app.run (args);
    }
}
