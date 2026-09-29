"
Simulator component for BPMN data objects. Handles data state availability and data token flow during execution.
"
Class {
	#name : 'OPBPMNDataObjectSimulator',
	#superclass : 'OPBPMNNodeSimulator',
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'actions' }
OPBPMNDataObjectSimulator >> fire [

	self bpmnTokens: 0
]
