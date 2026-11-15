"
Validates serialization of BPMN domain models and diagrams containing pools and lanes into BPMN 2.0 XML format.
"
Class {
	#name : 'OPBPMNXMLWriterTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-XML-Tests-Writer',
	#package : 'OpenPonk-BPMN-XML-Tests',
	#tag : 'Writer'
}

{ #category : 'tests' }
OPBPMNXMLWriterTest >> testExportPoolWithLanesDoesNotCrashOnPrintIdType [

	| pool lane task visitor xmlContent expectedXml |
	pool := OPBPMNPoolModel new.
	pool name: 'Participant Pool'.

	lane := OPBPMNLaneModel new.
	lane name: 'Lane 1'.
	pool addLane: lane.

	task := OPBPMNActivityModel new.
	task name: 'User Task'.
	lane add: task.

	visitor := OPBPMNXMLWriterVisitor new.

	"Must serialize without MessageNotUnderstood: printIdType"
	visitor visitElement: pool.
	xmlContent := visitor contents.

	expectedXml := String streamContents: [ :stream |
			               stream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'.
			               stream cr.
			               stream nextPutAll: '<bpmn:process name="Participant Pool" id="_6-'.
			               stream nextPutAll: pool uuid asString.
			               stream nextPutAll: '">'.
			               stream cr.
			               stream nextPutAll: '    <bpmn:laneSet id="laneSet_'.
			               stream nextPutAll: pool uuid asString.
			               stream nextPutAll: '">'.
			               stream cr.
			               stream nextPutAll: '        <bpmn:lane name="Lane 1" id="_6-'.
			               stream nextPutAll: lane uuid asString.
			               stream nextPutAll: '">'.
			               stream cr.
			               stream nextPutAll: '            <bpmn:flowNodeRef>_6-'.
			               stream nextPutAll: task uuid asString.
			               stream nextPutAll: '</bpmn:flowNodeRef>'.
			               stream cr.
			               stream nextPutAll: '        </bpmn:lane>'.
			               stream cr.
			               stream nextPutAll: '    </bpmn:laneSet>'.
			               stream cr.
			               stream nextPutAll: '    <bpmn:task name="User Task" id="_6-'.
			               stream nextPutAll: task uuid asString.
			               stream nextPutAll: '"/>'.
			               stream cr.
			               stream nextPutAll: '</bpmn:process>' ].
	self assert: xmlContent equals: expectedXml
]
