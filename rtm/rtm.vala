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
    public class Rtm : Object
    {
        class Entry : Object
        {
            public string key;
            public string val;

            public Entry (string key, string val)
            {
                this.key = key;
                this.val = val;
            }
        }

        private HttpProxyInterface proxy;
        private string api_key;
        private string secret;

        public signal void authentication(string url);

        public Rtm (string api_key, string secret, HttpProxyInterface proxy)
        {
            this.proxy = proxy;
            this.api_key = api_key;
            this.secret = secret;
        }

        public void get_lists ()
        {

        }

        public void authenticate ()
        {
            var parameters = new List<Entry> ();

            parameters.append (new Entry ("api_key", this.api_key));
            parameters.append (new Entry ("perms", "read,write"));

            var query = create_signed_query (parameters);

            proxy.request("http://www.rememberthemilk.com/services/auth/?" + query);
        }

        private string create_signed_query (List<Entry> parameters)
        {
            parameters.sort ((a,b) => {
                if (a.key == b.key) return 0;

                return a.key > b.key ? 1 : -1;
            });

            string to_sign = "";

            parameters.foreach ((entry) => {
                to_sign += entry.key + entry.val;
            });

            to_sign = this.secret + to_sign;

            var checksum = new Checksum (ChecksumType.MD5);

            print (to_sign + "\n");

            var to_sign_array = (uchar[]) to_sign.to_utf8 ();

            checksum.update (to_sign_array, to_sign_array.length);
            var signature = checksum.get_string ();

            var query = "";
            parameters.foreach ((entry) => {
                query += entry.key + "=" + entry.val + "&";
            });

            query += "api_sig=" + signature;

            return query;
        }
    }
}

// vim: ts=4 sw=4
