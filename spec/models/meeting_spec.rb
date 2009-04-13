require File.dirname(__FILE__) + '/../spec_helper'

describe Meeting do
  before(:each) do
    @meeting = Meeting.find_by_sourced_id("sample")
  end

  it "should return properly formatted XML" do
    doc = Hpricot("<meeting>
    <sourced_id>sample</sourced_id>
    <target_sourced_id>sample</target_sourced_id>
    <target_type>Section</target_type>
    <i_calendar>BEGIN:VCALENDAR
CALSCALE:GREGORIAN
PRODID:-//Apple Computer, Inc//iCal 1.5//EN
VERSION:2.0
METHOD:REPLY
BEGIN:VEVENT
ATTENDEE;CN=\"Sam Roberts/Certicom\";PARTSTAT=ACCEPTED;ROLE=REQ-PARTICIPANT;R
 SVP=TRUE:mailto:SRoberts@certicom.com
CLASS:PUBLIC
DTEND;TZID=Pacific:20040415T130000
DTSTAMP:20040319T205045Z
DTSTART;TZID=Pacific:20040415T120000
ORGANIZER;CN=\"Gary Pope/Certicom\":mailto:gpope@certicom.com
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
    </meeting>")
    out = @meeting.return_xml
    Hpricot(out).to_s.should == doc.to_s
  end
end

