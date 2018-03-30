 /*-
 * Copyright (c) 2018 Tudor Plugaru (https://github.com/PlugaruT/pwned-checker)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA.
 *
 * Authored by: Tudor Plugaru <plugaru.tudor@gmail.com>
 */


public class MainWindow : Gtk.Window {
    private PwnedAPI api;
    private Gtk.Image password_response_icon;
    private Gtk.Label password_response_label;
    private Gtk.Image email_response_icon;
    private Gtk.Label email_response_label;
    private Gtk.Spinner spinner;
    private Gtk.Button check_button;
    private Gtk.Entry password_entry;
    private Gtk.Entry email_entry;


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

        var header_label = new Gtk.Label (_("Please enter password or email you want to be checked on <a href='haveibeenpwned.com'>haveibeenpwned.com</a>"));
        header_label.set_use_markup (true);
        header_label.set_line_wrap (true);

        // Password
        password_response_label = new Gtk.Label (_("Enter password to be checked!"));
        password_response_label.hexpand = true;
        password_response_icon = new Gtk.Image.from_icon_name ("dialog-information", Gtk.IconSize.INVALID);
        password_response_icon.pixel_size = 32;

        password_entry = new Gtk.Entry ();
        password_entry.hexpand = true;
        password_entry.placeholder_text = _("Password");
        password_entry.set_visibility (false);
        password_entry.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "image-red-eye-symbolic");
        password_entry.icon_press.connect ( () => {
            password_entry.set_visibility (!password_entry.visibility);
        });
        password_entry.changed.connect (toggle_button_sensitivity);


        // Email
        email_entry = new Gtk.Entry ();
        email_entry.hexpand = true;
        email_entry.placeholder_text = _("Email");
        email_entry.changed.connect (toggle_button_sensitivity);

        email_response_label = new Gtk.Label (_("Enter email to be checked!"));
        email_response_label.hexpand = true;
        email_response_icon = new Gtk.Image.from_icon_name ("dialog-information", Gtk.IconSize.INVALID);
        email_response_icon.pixel_size = 32;


        // Check button
        check_button = new Gtk.Button.with_label (_("Check!"));
        check_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
        check_button.sensitive = false;
        check_button.clicked.connect ( () => {
            if (!is_empty(password_entry.text)) {
                handle_password_response ();
            }

            if (!is_empty(email_entry.text)) {
                handle_email_response ();
            }
        });

        main_layout.attach (header_label, 0, 1, 2, 1);
        main_layout.attach (password_entry, 0, 2, 2, 1);
        main_layout.attach (password_response_icon, 0, 3, 1, 1);
        main_layout.attach (password_response_label, 1, 3, 1, 1);
        main_layout.attach (email_entry, 0, 4, 2, 1);
        main_layout.attach (email_response_icon, 0, 5, 1, 1);
        main_layout.attach (email_response_label, 1, 5, 1, 1);
        main_layout.attach (check_button, 0, 6, 2, 1);

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

    private void switch_icon (Gtk.Image icon, string icon_name) {
        icon.icon_name = icon_name;
    }

    private void show_spinner () {
        spinner.start ();
    }

    private void hide_spinner () {
        spinner.stop ();
    }

    private void toggle_button_sensitivity () {
        check_button.sensitive = !is_empty(password_entry.text) || !is_empty(email_entry.text);
    }

    private bool is_empty (string str) {
        return str == "" || str == null;
    }

    private void handle_password_response () {
        var password_check = api.check_password (password_entry.text.to_string());
        if (password_check != "-1") {
            switch_icon(password_response_icon, "dialog-error");
            password_response_label.set_label (_("Your password was pwned %s times!").printf (password_check));
        } else {
            switch_icon(password_response_icon, "process-completed");
            password_response_label.set_label (_("You can stay calm, the password is good!"));
        }
    }

    private void handle_email_response () {
        var breaches = api.check_account (email_entry.text.to_string());
        if (breaches.length > 0) {
            switch_icon(email_response_icon, "dialog-error");
            email_response_label.set_label (_("Your account was involved in %s breaches!").printf (breaches.length.to_string ()));
            email_response_label.set_tooltip_text (string.joinv(", ", breaches));
        } else {
            switch_icon(email_response_icon, "process-completed");
            email_response_label.set_label (_("Congratulations, you were carefully enough till now!"));
        }
    }
}
