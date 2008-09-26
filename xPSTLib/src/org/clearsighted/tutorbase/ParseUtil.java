/*
Copyright (c) Clearsighted 2006-08 stephen@clearsighted.net

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/

package org.clearsighted.tutorbase;

public class ParseUtil
{
	public static String stripComment(String in)
	{
		int idx = in.indexOf("//");
		if (idx == -1)
			return in;
		else
			return in.substring(0, idx);
	}

	public static String join(String[] strs, String delim)
	{
		StringBuffer ret = new StringBuffer();
		for (int i = 0; i < strs.length - 1; i++)
		{
			ret.append(strs[i]);
			ret.append(delim);
		}
		if (strs.length > 0)
			ret.append(strs[strs.length - 1]);
		return ret.toString();
	}
}
