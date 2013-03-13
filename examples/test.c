/* test.c
 *
 * Copyright (C) 2006-2012 Sawtooth Consulting Ltd.
 *
 * This file is part of the yaSSL Embedded Web Server Documentation 
 * and Examples.
 *
 * The yaSSL Embededed Web Server is free software; you can redistribute 
 * it and/or modify it under the terms of the GNU General Public License 
 * as published by the Free Software Foundation; either version 2 of the 
 * License, or (at your option) any later version.
 *
 * The yaSSL Embedded Web Server is distributed in the hope that it will 
 * be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
 */

#include "stdio.h"

int main()
{
	int number_a = 10;
	int number_b = 33;
	int sum = number_a + number_b;
	
	printf("First Number = %d\n", number_a);
	printf("Second Number = %d\n", number_b);
	printf("Sum = %d\n", sum);
	
	return 0;
}
