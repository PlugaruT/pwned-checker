public class MainWindow : Gtk.Window {
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
    var header = new Gtk.HeaderBar ();
    header.show_close_button = true;
    var header_context = header.get_style_context ();
    header_context.add_class ("titlebar");
    header_context.add_class ("default-decoration");
    header_context.add_class (Gtk.STYLE_CLASS_FLAT);

    var main_layout = new Gtk.Grid ();
    main_layout.column_spacing = 6;
    main_layout.height_request = 258;
    main_layout.row_spacing = 6;
    main_layout.width_request = 710;


    set_titlebar (header);
    add (main_layout);
  }

}
