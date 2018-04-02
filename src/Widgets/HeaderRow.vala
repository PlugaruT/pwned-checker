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
    public class HeaderRow : Gtk.Grid {
        private Gtk.Label label;

        public HeaderRow() {
            hexpand = true;
            column_spacing = 6;
            row_spacing = 12;

            label = new Gtk.Label (_ ("Please enter password or email you want to be checked on <a href='haveibeenpwned.com'>haveibeenpwned.com</a>"));
            label.hexpand = true;
            label.set_use_markup (true);
            label.set_line_wrap (true);

            attach (label, 0, 1, 1, 1);
        }
    }
}
