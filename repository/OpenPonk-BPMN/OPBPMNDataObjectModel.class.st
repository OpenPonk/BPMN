"
I represent a BPMN Data Object in the underlying semantic model, tracking data requirements or outputs for activities.
"
Class {
	#name : 'OPBPMNDataObjectModel',
	#superclass : 'OPBPMNSemanticNodeModel',
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'updating' }
OPBPMNDataObjectModel >> changed [
	super changed.
	owner changed
]

{ #category : 'accessing' }
OPBPMNDataObjectModel >> defaultType [
	^ OPBPMNNodeType DataObject
]

{ #category : 'printing' }
OPBPMNDataObjectModel >> printType [
	^ 'dataObject'
]
