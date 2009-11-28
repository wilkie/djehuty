/*
 * qos.d
 *
 * This module binds Qos.h to D. The original copyright notice
 * is preserved below.
 *
 * Author: Dave Wilkinson
 * Originated: November 25th, 2009
 *
 */

module binding.win32.qos;

import binding.c;

import binding.win32.windef;
import binding.win32.winbase;
import binding.win32.winnt;

/*++

Copyright (c) Microsoft Corporation. All rights reserved.

Module Name:

    qos.h - QoS definitions for NDIS components.

Abstract:

    This module defines the Quality of Service structures and types used
    by Winsock applications.

WARNING:

    This api is deprecated and will be removed in a future release of Windows.
    Please use the QOS2.h api.

Revision History:

--*/


/*
 *  Definitions for valued-based Service Type for each direction of data flow.
 */

typedef ULONG   SERVICETYPE;

const auto SERVICETYPE_NOTRAFFIC                = 0x00000000  ; /* No data in this 
                                                         * direction */
const auto SERVICETYPE_BESTEFFORT               = 0x00000001  ; /* Best Effort */
const auto SERVICETYPE_CONTROLLEDLOAD           = 0x00000002  ; /* Controlled Load */
const auto SERVICETYPE_GUARANTEED               = 0x00000003  ; /* Guaranteed */

const auto SERVICETYPE_NETWORK_UNAVAILABLE      = 0x00000004  ; /* Used to notify 
                                                         * change to user */
const auto SERVICETYPE_GENERAL_INFORMATION      = 0x00000005  ; /* corresponds to 
                                                         * "General Parameters"
                                                         * defined by IntServ */
const auto SERVICETYPE_NOCHANGE                 = 0x00000006  ; /* used to indicate
                                                         * that the flow spec
                                                         * contains no change
                                                         * from any previous
                                                         * one */
const auto SERVICETYPE_NONCONFORMING            = 0x00000009  ; /* Non-Conforming Traffic */
const auto SERVICETYPE_NETWORK_CONTROL          = 0x0000000A  ; /* Network Control traffic */
const auto SERVICETYPE_QUALITATIVE              = 0x0000000D  ; /* Qualitative applications */ 



/*********  The usage of these is currently not supported.  ***************/
const auto SERVICE_BESTEFFORT                   = 0x80010000;
const auto SERVICE_CONTROLLEDLOAD               = 0x80020000;
const auto SERVICE_GUARANTEED                   = 0x80040000;
const auto SERVICE_QUALITATIVE                  = 0x80200000;
/* **************************** ***** ************************************ */



/*
 * Flags to control the usage of RSVP on this flow.
 */

/*
 * to turn off traffic control, 'OR' ( | ) this flag with the 
 * ServiceType field in the FLOWSPEC
 */
const auto SERVICE_NO_TRAFFIC_CONTROL    = 0x81000000;


/*
 * this flag can be used to prevent any rsvp signaling messages from being 
 * sent. Local traffic control will be invoked, but no RSVP Path messages 
 * will be sent.This flag can also be used in conjunction with a receiving 
 * flowspec to suppress the automatic generation of a Reserve message.  
 * The application would receive notification that a Path  message had arrived 
 * and would then need to alter the QOS by issuing WSAIoctl( SIO_SET_QOS ), 
 * to unset this flag and thereby causing Reserve messages to go out.
 */

const auto SERVICE_NO_QOS_SIGNALING    = 0x40000000;




/*
 *  Flow Specifications for each direction of data flow.
 */
struct FLOWSPEC {
    ULONG       TokenRate;              /* In Bytes/sec */
    ULONG       TokenBucketSize;        /* In Bytes */
    ULONG       PeakBandwidth;          /* In Bytes/sec */
    ULONG       Latency;                /* In microseconds */
    ULONG       DelayVariation;         /* In microseconds */
    SERVICETYPE ServiceType;
    ULONG       MaxSduSize;             /* In Bytes */
    ULONG       MinimumPolicedSize;     /* In Bytes */

}

typedef FLOWSPEC* PFLOWSPEC;
typedef FLOWSPEC*  LPFLOWSPEC;

/*
 * this value can be used in the FLOWSPEC structure to instruct the Rsvp Service 
 * provider to derive the appropriate default value for the parameter.  Note 
 * that not all values in the FLOWSPEC structure can be defaults. In the
 * ReceivingFlowspec, all parameters can be defaulted except the ServiceType.  
 * In the SendingFlowspec, the MaxSduSize and MinimumPolicedSize can be
 * defaulted. Other defaults may be possible. Refer to the appropriate
 * documentation.
 */
const auto QOS_NOT_SPECIFIED      = 0xFFFFFFFF;

/*
 * define a value that can be used for the PeakBandwidth, which will map into 
 * positive infinity when the FLOWSPEC is converted into IntServ floating point 
 * format.  We can't use (-1) because that value was previously defined to mean
 * "select the default".
 */
const auto    POSITIVE_INFINITY_RATE     = 0xFFFFFFFE;



/*
 * the provider specific structure can have a number of objects in it.
 * Each next structure in the
 * ProviderSpecific will be the QOS_OBJECT_HDR struct that prefaces the actual
 * data with a type and length for that object.  This QOS_OBJECT struct can 
 * repeat several times if there are several objects.  This list of objects
 * terminates either when the buffer length has been reached ( WSABUF ) or
 * an object of type QOS_END_OF_LIST is encountered.
 */
struct QOS_OBJECT_HDR {

    ULONG   ObjectType;
    ULONG   ObjectLength;  /* the length of object buffer INCLUDING 
                            * this header */

}

typedef QOS_OBJECT_HDR* LPQOS_OBJECT_HDR;


/*
 * general QOS objects start at this offset from the base and have a range 
 * of 1000
 */
const auto    QOS_GENERAL_ID_BASE                      =2000;
const auto    QOS_OBJECT_END_OF_LIST   =                (0x00000001 + QOS_GENERAL_ID_BASE) ;
          /* QOS_End_of_list structure passed */
const auto    QOS_OBJECT_SD_MODE      =                 (0x00000002 + QOS_GENERAL_ID_BASE) ;
          /* QOS_ShapeDiscard structure passed */
const auto    QOS_OBJECT_SHAPING_RATE=	           (0x00000003 + QOS_GENERAL_ID_BASE);
          /* QOS_ShapingRate structure */
const auto    QOS_OBJECT_DESTADDR=                      (0x00000004 + QOS_GENERAL_ID_BASE);
          /* QOS_DestAddr structure (defined in qossp.h) */


/*
 * This structure is used to define the behaviour that the traffic
 * control packet shaper will apply to the flow.
 *
 * TC_NONCONF_BORROW - the flow will receive resources remaining 
 *  after all higher priority flows have been serviced. If a 
 *  TokenRate is specified, packets may be non-conforming and
 *  will be demoted to less than best-effort priority.
 *  
 * TC_NONCONF_SHAPE - TokenRate must be specified. Non-conforming
 *  packets will be retianed in the packet shaper until they become
 *  conforming.
 *
 * TC_NONCONF_DISCARD - TokenRate must be specified. Non-conforming
 *  packets will be discarded.
 *
 */

struct QOS_SD_MODE {

    QOS_OBJECT_HDR   ObjectHdr;
    ULONG            ShapeDiscardMode;

}

typedef QOS_SD_MODE* LPQOS_SD_MODE;

const auto TC_NONCONF_BORROW       = 0;
const auto TC_NONCONF_SHAPE        = 1;
const auto TC_NONCONF_DISCARD      = 2;
const auto TC_NONCONF_BORROW_PLUS  = 3 ; // Not supported currently


/*
 * This structure allows an app to specify a prorated "average token rate" using by
 * the traffic shaper under SHAPE modehaper queue. It is expressed in bytes per sec.
 *
 * ShapingRate (bytes per sec.)
 *
 */

struct QOS_SHAPING_RATE {

    QOS_OBJECT_HDR   ObjectHdr;
    ULONG            ShapingRate;

}

typedef QOS_SHAPING_RATE* LPQOS_SHAPING_RATE;
