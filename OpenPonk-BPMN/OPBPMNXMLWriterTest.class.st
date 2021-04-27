Class {
	#name : #OPBPMNXMLWriterTest,
	#superclass : #TestCase,
	#instVars : [
		'writer'
	],
	#category : #'OpenPonk-BPMN-Tests'
}

{ #category : #running }
OPBPMNXMLWriterTest >> setUp [
	super setUp.
	writer := XMLWriter new.
	writer formatter: OPBPMNXMLPrettyWriter new.
	writer lineBreak: '&#10;'.
	writer xml encoding: 'UTF-8'.
]

{ #category : #tests }
OPBPMNXMLWriterTest >> testWriteClearDiagram [
	| diagramController result |
	diagramController := OPBPMNDiagramController new.
	result := OPBPMNXMLWriter toString: diagramController.
	self assert: result equals: '<?xml version="1.0" encoding="UTF-8"?>
<semantic:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:semantic="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL">
    <semantic:process isExecutable="false" id="process_fa3f8c24-547d-0d00-897c-b01a0a761af9"/>
    <bpmndi:BPMNDiagram id="BPMNDiagram_fa3f8c24-547d-0d00-897c-b01a0a761af9" name="New Project" resolution="96.0">
        <bpmndi:BPMNPlane bpmnElement="process_fa3f8c24-547d-0d00-897c-b01a0a761af9"/>
    </bpmndi:BPMNDiagram>
</semantic:definitions>'
]
