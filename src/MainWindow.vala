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

namespace PwnedChecker {
    public class MainWindow : Gtk.Window {
        private PwnedChecker.Services.PwnedAPI api;
        private PwnedChecker.Widgets.HeaderRow header_row;
        private PwnedChecker.Widgets.PasswordRow password_row;
        private PwnedChecker.Widgets.AccountRow account_row;
        private Gtk.Spinner spinner;
        private Gtk.Button check_button;

        public MainWindow (Gtk.Application application) {
            Object (application: application);
        }

        construct {
            border_width = 0;
            icon_name = "com.github.plugarut.pwned-checker";
            resizable = false;
            title = _ ("Pwned Checker");
            window_position = Gtk.WindowPosition.CENTER;

            api = new PwnedChecker.Services.PwnedAPI ();
            api.start_loading.connect (
                ()=>{
                    spinner.start ();
                });
            api.end_loading.connect (
                ()=>{
                    spinner.stop ();
                });

            var layout = new Gtk.Grid ();
            layout.hexpand = true;
            layout.margin = 20;
            layout.column_spacing = 6;
            layout.row_spacing = 12;

            spinner = new Gtk.Spinner ();

            header_row = new PwnedChecker.Widgets.HeaderRow ();
            password_row = new PwnedChecker.Widgets.PasswordRow ();
            password_row.on_text_change.connect (toggle_button_sensitivity);
            account_row = new PwnedChecker.Widgets.AccountRow ();
            account_row.on_text_change.connect (toggle_button_sensitivity);

            // Check button
            check_button = new Gtk.Button.with_label (_ ("Check!"));
            check_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            check_button.sensitive = false;
            check_button.clicked.connect (
                () => {
                    if (!is_empty (password_row.get_password ())) {
                        check_password ();
                    }

                    if (!is_empty (account_row.get_account ())) {
                        check_account ();
                    }
                });

            layout.attach (header_row, 0, 1, 1, 1);
            layout.attach (password_row, 0, 2, 1, 1);
            layout.attach (account_row, 0, 3, 1, 1);
            layout.attach (check_button, 0, 4, 1, 1);

            var header = new Gtk.HeaderBar ();
            header.show_close_button = true;
            header.pack_end (spinner);

            var header_context = header.get_style_context ();
            header_context.add_class ("titlebar");
            header_context.add_class ("default-decoration");
            header_context.add_class (Gtk.STYLE_CLASS_FLAT);

            set_titlebar (header);
            add (layout);
        }

        private void toggle_button_sensitivity () {
            check_button.sensitive =  !is_empty (account_row.get_account ()) || !is_empty (password_row.get_password ());
        }

        private bool is_empty (string str) {
            return str == "" || str == null;
        }

        private void check_password () {
            var response = api.check_password (password_row.get_password ());
            if (response > 0) {
                password_row.danger (response);
            } else {
                password_row.ok ();
            }
        }

        private void check_account () {
            var response = api.check_account (account_row.get_account ());
            if (response.length > 0) {
                account_row.danger (response);
            } else {
                account_row.ok ();
            }
        }
    }
}
