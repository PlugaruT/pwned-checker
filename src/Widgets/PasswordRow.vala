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
    public class PasswordRow : Gtk.Grid {
        public signal void on_text_change ();

        private Gtk.Label label;
        private Gtk.Entry entry;
        private Gtk.Image icon;

        public PasswordRow() {
            hexpand = true;
            column_spacing = 6;
            row_spacing = 12;

            label = new Gtk.Label (_ ("Enter password to be checked!"));
            label.hexpand = true;

            icon = new Gtk.Image.from_icon_name (PwnedChecker.Constants.Icons.INFO.icon (), Gtk.IconSize.INVALID);
            icon.pixel_size = 32;

            entry = new Gtk.Entry ();
            entry.hexpand = true;
            entry.placeholder_text = _ ("Password");
            entry.set_visibility (false);
            entry.set_icon_from_icon_name (Gtk.EntryIconPosition.SECONDARY, "image-red-eye-symbolic");
            entry.icon_press.connect (
                () => {
                    entry.set_visibility (!entry.visibility);
                });
            entry.changed.connect (
                ()=>{
                    on_text_change ();
                });

            attach (entry, 0, 1, 2, 1);
            attach (icon,  0, 2, 1, 1);
            attach (label, 1, 2, 1, 1);
        }

        public void danger (int number) {
            icon.icon_name = PwnedChecker.Constants.Icons.DANGER.icon ();
            label.set_label (_ ("Your password was pwned %s times!").printf (number.to_string ()));
        }

        public void ok () {
            icon.icon_name = PwnedChecker.Constants.Icons.OK.icon ();
            label.set_label (_ ("You can stay calm, the password is good!"));
        }

        public string get_password () {
            return entry.text.to_string ();
        }
    }
}
