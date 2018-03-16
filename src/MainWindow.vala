public class MainWindow : Gtk.Window {
    private PwnedAPI api;
    private Gtk.Label password_response_label;
    private Gtk.Label email_response_label;

  public MainWindow (Gtk.Application application) {
    Object (
        application: application,
        border_width: 0,
        icon_name: "com.github.plugarut.pwned-checker",
        resizable: false,
        title: _("Pwned Checker"),
        window_position: Gtk.WindowPosition.CENTER
    );
    api = new PwnedAPI();
  }

  construct {
    var header = new Gtk.HeaderBar ();
    header.show_close_button = true;
    var header_context = header.get_style_context ();
    header_context.add_class ("titlebar");
    header_context.add_class ("default-decoration");
    header_context.add_class (Gtk.STYLE_CLASS_FLAT);

    var main_layout = new Gtk.Grid ();
    main_layout.column_spacing = 6;
    main_layout.height_request = 260;
    main_layout.row_spacing = 6;
    main_layout.width_request = 400;

    password_response_label = create_label(_("Enter password to be checked!"));
    email_response_label = create_label(_("Enter email to be checked!"));

    var header_grid = create_grid ();
    header_grid.height_request = 60;
    header_grid.margin = 5;
    header_grid.margin_start = 50;
    header_grid.margin_end = 50;

    var password_grid = create_grid ();
    password_grid.column_spacing = 6;
    password_grid.height_request = 60;

    var email_grid = create_grid ();
    email_grid.column_spacing = 6;
    email_grid.height_request = 60;

    var password_entry = new Gtk.Entry();
    password_entry.hexpand = true;
    password_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "image-red-eye-symbolic");
    password_entry.placeholder_text = _("Password");
    password_entry.set_visibility(false);
    password_entry.icon_press.connect(() => {
        password_entry.set_visibility(!password_entry.visibility);
    });

    var email_entry = new Gtk.Entry();
    email_entry.hexpand = true;
    email_entry.placeholder_text = _("test@email.com");


    var check_button = new Gtk.Button.with_label (_("Check!"));
    check_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
    check_button.sensitive = true;
    check_button.margin_start = 40;
    check_button.margin_end = 40;
    check_button.clicked.connect(() => {
       if(api.check_password(password_entry.text.to_string())){
            password_response_label.set_label("pwned");
       } else {
            password_response_label.set_label("not pwned");
       }

    });



    var header_label = new Gtk.Label(_("Please enter password or email you want to be checked on <a href='haveibeenpwned.com'>haveibeenpwned.com</a>"));
    header_label.margin_top = 10;
    header_label.set_use_markup (true);
    header_label.set_line_wrap (true);


    header_grid.attach (header_label, 0, 1, 1, 1);

    password_grid.attach (password_entry, 0, 1, 1, 1);
    password_grid.attach (password_response_label, 0, 2, 1, 1);

    email_grid.attach (email_entry, 0, 1, 1, 1);
    email_grid.attach (email_response_label, 0, 2, 1, 1);

    main_layout.attach (header_grid, 1, 1, 2, 1);
    main_layout.attach (password_grid, 1, 2, 1 ,1);
    main_layout.attach (email_grid, 2, 2, 1, 1);
    main_layout.attach (check_button, 1, 3, 2, 1);

    set_titlebar (header);
    add (main_layout);
  }

  private Gtk.Label create_label (string lbl) {
    var label = new Gtk.Label(lbl);
    label.margin_top = 5;
    label.margin_start = 40;
    label.margin_end = 40;
    return label;
  }

  private Gtk.Grid create_grid () {
    var grid = new Gtk.Grid ();
    grid.margin = 20;
    grid.hexpand = true;
    return grid;
  }

}
