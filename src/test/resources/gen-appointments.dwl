%dw 2.0
import * from dw::core::Periods
output application/json
var patientIds = patients map ($.id as Number)
var facilityIds = facilities map ($.id as Number)

fun skewedCount(max) = min([randomInt(max) + 1, randomInt(max) + 1, randomInt(max) + 1]) default 0

fun randomVisitInfo() = {
    patient: patientIds[randomInt(sizeOf(patientIds))],
    facility: facilityIds[randomInt(sizeOf(facilityIds))],
    count: skewedCount(5),
    start: |2024-02-20| + days(randomInt(60))
}

fun randomAppointments(visitInfo) = 
    (0 to skewedCount(12)) reduce (num, acc = []) -> acc << do {
        var start = if (num == 0) visitInfo.start 
            else acc[-1].start + days((randomInt(10) + 1) * 7)
        ---
        {
            start: start,
            description: descriptions[randomInt(sizeOf(descriptions))].description,
            patient: visitInfo.patient,
            facility: visitInfo.facility
        }
    }
---
{
    data: (1 to 10) map randomVisitInfo() flatMap randomAppointments($)
}