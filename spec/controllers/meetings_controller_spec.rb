require File.dirname(__FILE__) + '/../spec_helper'

describe MeetingsController do
  describe "put requests" do
    it "should succeed at a put with an OK meeting" do
      request.env['RAW_POST_DATA'] = "<meeting>
    <sourced_id>sample2</sourced_id>
    <target_sourced_id>sample</target_sourced_id>
    <target_type>Section</target_type>
    <i_calendar>BEGIN:VCALENDAR
CALSCALE:GREGORIAN
PRODID:-//Apple Computer, Inc//iCal 1.5//EN
VERSION:2.0
METHOD:REPLY
BEGIN:VEVENT
CLASS:PUBLIC
DTEND;TZID=Pacific:20040415T130000
DTSTAMP:20040319T205045Z
DTSTART;TZID=Pacific:20040415T120000
SEQUENCE:0
SUMMARY:hjold intyel
TRANSP:OPAQUE
UID:3E19204063C93D2388256E5C006BF8D9-Lotus_Notes_Generated
X-LOTUS-BROADCAST:FALSE
X-LOTUS-CHILDUID:3E19204063C93D2388256E5C006BF8D9
X-LOTUS-NOTESVERSION:2
X-LOTUS-NOTICETYPE:I
X-LOTUS-UPDATE-SEQ:1
X-LOTUS-UPDATE-WISL:$S:1;$L:1;$B:1;$R:1;$E:1
END:VEVENT
END:VCALENDAR
</i_calendar>
    </meeting>"
      put :update
      response.status.should == "201 Created"
    end
  end
end

