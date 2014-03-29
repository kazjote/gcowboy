/*
 * Copyright (C) 2014 Kacper Bielecki <kazjote@gmail.com>
 * 
 * GCowboy is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * GCowboy is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

namespace Rtm
{
    public class Authenticator : Object
    {
        public signal void authorization (string url);
        public signal void authenticated (string token);

        private HttpProxyInterface proxy;
        private string secret;
        private string apikey;
        private string token;

        public Authenticator (HttpProxyInterface proxy, string secret, string apikey)
        {
            this.proxy = proxy;
            this.secret = secret;
            this.apikey = apikey;
        }

        public void reauthenticate ()
        {
            var requester = new Requester (proxy, secret);
            requester.add_parameter ("api_key", this.apikey);

            Frob frob = requester.request("rtm.auth.getFrob").frob;

            requester = new Requester (proxy, secret);
            requester.add_parameter ("api_key", this.apikey);
            requester.add_parameter ("perms", "write");
            requester.add_parameter ("frob", frob.frob);

            authorization ("https://www.rememberthemilk.com/services/auth/?" + requester.create_signed_query ());

            requester = new Requester (proxy, secret);
            requester.add_parameter ("api_key", this.apikey);
            requester.add_parameter ("frob", frob.frob);

            Response response = null;

            while (response == null || response.stat != Stat.OK) {
                if (Environment.get_variable("GCOWBOY_ENV") != "test") {
                    GLib.Thread.usleep(2 * 1000000);
                }

                response = requester.request ("rtm.auth.getToken");
            }

            token = response.token.token;

            authenticated (token);
        }
    }
}

// vim: ts=4 sw=4
