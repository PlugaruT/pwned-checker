public class MainWindow : Gtk.Window {
    private PwnedAPI api;
    private Gtk.Image password_response_icon;
    private Gtk.Label password_response_label;
    private Gtk.Spinner spinner;

    public MainWindow (Gtk.Application application) {
    Object (
            application: application,
            border_width: 0,
            icon_name: "com.github.plugarut.pwned-checker",
            resizable: false,
            title: _("Pwned Checker"),
            window_position: Gtk.WindowPosition.CENTER
        );
    }

    construct {
        spinner = new Gtk.Spinner ();

        api = new PwnedAPI ();
        api.start_loading.connect (show_spinner);
        api.end_loading.connect (hide_spinner);

        var main_layout = new Gtk.Grid ();
        main_layout.hexpand = true;
        main_layout.margin = 20;
        main_layout.column_spacing = 6;
        main_layout.row_spacing = 12;

        password_response_label = new Gtk.Label (_("Enter password to be checked!"));
        password_response_label.hexpand = true;
        password_response_icon = new Gtk.Image.from_icon_name ("dialog-information", Gtk.IconSize.INVALID);
        password_response_icon.pixel_size = 32;

        var password_entry = new Gtk.Entry ();
        password_entry.hexpand = true;
        password_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "image-red-eye-symbolic");
        password_entry.placeholder_text = _("Password");
        password_entry.set_visibility (false);
        password_entry.icon_press.connect ( () => {
            password_entry.set_visibility (!password_entry.visibility);
        });

        var check_button = new Gtk.Button.with_label (_("Check!"));
        check_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        check_button.sensitive = true;
        check_button.clicked.connect ( () => {
            var password_check = api.check_password (password_entry.text.to_string());
            if (password_check != "-1") {
                switch_icon("dialog-error");
                password_response_label.set_label (_("Your password was pwned %s times!").printf (password_check));
            } else {
                switch_icon("process-completed");
                password_response_label.set_label (_("You can stay calm, the password is good!"));
            }
        });

        var header_label = new Gtk.Label (_("Please enter password you want to be checked on <a href='haveibeenpwned.com'>haveibeenpwned.com</a>"));
        header_label.set_use_markup (true);
        header_label.set_line_wrap (true);

        main_layout.attach (header_label, 0, 1, 2, 1);
        main_layout.attach (password_entry, 0, 2, 2, 1);
        main_layout.attach (password_response_icon, 0, 3, 1, 1);
        main_layout.attach (password_response_label, 1, 3, 1, 1);
        main_layout.attach (check_button, 0, 4, 2, 1);

        var header = new Gtk.HeaderBar ();
        header.show_close_button = true;
        header.pack_end (spinner);
        var header_context = header.get_style_context ();
        header_context.add_class ("titlebar");
        header_context.add_class ("default-decoration");
        header_context.add_class (Gtk.STYLE_CLASS_FLAT);

        set_titlebar (header);
        add (main_layout);
    }

    private void switch_icon (string icon_name) {
        password_response_icon.icon_name = icon_name;
    }

    private void show_spinner () {
        spinner.start ();
    }

    private void hide_spinner () {
        spinner.stop ();
    }
}
