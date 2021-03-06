/*      -*- linux-c -*-
 *
 * (C) Copyright IBM Corp. 2004, 2005
 *
 *   This program is free software; you can redistribute it and/or modify 
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 2 of the License, or 
 *   (at your option) any later version.
 *   This program is distributed in the hope that it will be useful, 
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of 
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
 *   GNU General Public License for more details. 
 *   You should have received a copy of the GNU General Public License 
 *   along with this program; if not, write to the Free Software 
 *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 
 *   USA 
 *
 * Author(s):
 *      Carl McAdams <carlmc@us.ibm.com>
 *
 * Spec:        HPI-B.01.01
 * Function:    saHpiAutoInsertTimeoutSet
 * Description:
 *   Set the AutoInsertTimeout for all domains.
 *   saHpiAutoInsertTimeoutSet() returns SA_OK.
 * Line:        P142-16:P142-16
 *    
 */
#include <stdio.h>
#include "saf_test.h"

#define ONE_SECOND_TIMEOUT 1000000000

int ForEachDomain(SaHpiSessionIdT session_id)
{
	SaErrorT status;
	int retval = SAF_TEST_UNKNOWN;
	SaHpiDomainInfoT DomainInfo;
	SaHpiTimeoutT Timeout, Timeout_Save;
	SaHpiBoolT Restore = SAHPI_FALSE;

	status = saHpiDomainInfoGet(session_id, &DomainInfo);
	if (status != SA_OK) {
		e_print(saHpiDomainInfoGet, SA_OK, status);
		retval = SAF_TEST_UNRESOLVED;
	} else {
		if (DomainInfo.DomainCapabilities &
		    SAHPI_DOMAIN_CAP_AUTOINSERT_READ_ONLY) {
			// Domain doesn't have auto-insert
			// write capability
			retval = SAF_TEST_NOTSUPPORT;
		}
	}
	if (retval == SAF_TEST_UNKNOWN) {
		//
		//  Save the current AutoInsertTimeout
		//
		status = saHpiAutoInsertTimeoutGet(session_id, &Timeout_Save);
		if (status != SA_OK) {
			e_print(saHpiAutoInsertTimeoutGet, SA_OK, status);
			retval = SAF_TEST_UNRESOLVED;
		}
	}
	if (retval == SAF_TEST_UNKNOWN) {
		//
		//  Set the AutoInsertTimeout for all resources.
		//
		status =
		    saHpiAutoInsertTimeoutSet(session_id, ONE_SECOND_TIMEOUT);
		if (status != SA_OK) {
			e_print(saHpiAutoInsertTimeoutSet, SA_OK, status);
			retval = SAF_TEST_FAIL;
		} else
			Restore = SAHPI_TRUE;
	}
	if (retval == SAF_TEST_UNKNOWN) {
		//
		//  Get the Auto Insert Timeout which was just set
		//
		status = saHpiAutoInsertTimeoutGet(session_id, &Timeout);
		if (status != SA_OK) {
			e_print(saHpiAutoInsertTimeoutGet, SA_OK, status);
			retval = SAF_TEST_UNRESOLVED;
		}
	}
	if (retval == SAF_TEST_UNKNOWN) {
		//
		//  Compare the retrieved timeout to the set timeout.
		//
		if (Timeout != ONE_SECOND_TIMEOUT) {
			m_print
			    ("Function \"saHpiAutoInsertTimeoutSet\" works abnormally!\n"
			     "\tThe Retrieved timeout does not matched what was set!");
			retval = SAF_TEST_FAIL;
		} else
			retval = SAF_TEST_PASS;
	}
	if (Restore != SAHPI_FALSE) {
		//
		//  Restore the Timeout to the original state
		//
		status = saHpiAutoInsertTimeoutSet(session_id, Timeout_Save);
	}

	return (retval);
}

/**********************************************************
*   Main Function
*      takes no arguments
*      
*       returns: SAF_TEST_PASS when successful
*                SAF_TEST_FAIL when an unexpected error occurs
*************************************************************/
int main(int argc, char **argv)
{
	int retval = SAF_TEST_UNKNOWN;

	retval = process_all_domains(NULL, NULL, ForEachDomain);

	return (retval);
}
