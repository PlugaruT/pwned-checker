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

namespace PwnedChecker.Widgets {
    public class AccountRow : Gtk.Grid {
        public signal void on_text_change ();

        private Gtk.Label label;
        private Gtk.Entry entry;
        private Gtk.Image icon;

        public AccountRow() {
            hexpand = true;
            column_spacing = 6;
            row_spacing = 12;

            label = new Gtk.Label (_ ("Enter email to be checked!"));
            label.hexpand = true;

            icon = new Gtk.Image.from_icon_name (PwnedChecker.Constants.Icons.INFO.icon (), Gtk.IconSize.INVALID);
            icon.pixel_size = 32;

            entry = new Gtk.Entry ();
            entry.hexpand = true;
            entry.placeholder_text = _ ("Email");
            entry.changed.connect (
                () =>{
                    on_text_change ();
                });

            attach (entry, 0, 1, 2, 1);
            attach (icon,  0, 2, 1, 1);
            attach (label, 1, 2, 1, 1);
        }

        public void info () {
            label.set_label ("There are some problems with the API calls. Please contant the developer!");
        }

        public void danger (string[] breaches) {
            icon.icon_name = PwnedChecker.Constants.Icons.DANGER.icon ();
            label.set_label (_ ("Your account was involved in %s breaches!").printf (breaches.length.to_string ()));
            label.set_tooltip_text (string.joinv ("\n", breaches));
        }

        public void ok () {
            icon.icon_name = PwnedChecker.Constants.Icons.OK.icon ();
            label.set_label (_ ("Congratulations, you were carefully enough !"));
        }

        public string get_account () {
            return entry.text.to_string ();
        }
    }
}
