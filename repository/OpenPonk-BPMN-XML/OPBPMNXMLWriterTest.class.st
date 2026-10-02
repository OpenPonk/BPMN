"
Validates serialization of BPMN domain models and diagrams containing pools and lanes into BPMN 2.0 XML format.
"
Class {
	#name : 'OPBPMNXMLWriterTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-XML-Tests',
	#package : 'OpenPonk-BPMN-XML',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPBPMNXMLWriterTest >> testExportPoolWithLanesDoesNotCrashOnPrintIdType [
	| pool lane task visitor xmlContent |
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

	self assert: (xmlContent includesSubstring: 'Participant Pool').
	self assert: (xmlContent includesSubstring: 'Lane 1').
	self assert: (xmlContent includesSubstring: 'User Task')
]
