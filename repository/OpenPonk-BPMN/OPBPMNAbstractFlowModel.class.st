"
I am the abstract base model for BPMN flows, establishing the semantic connection between a source and a target element in the process graph.
"
Class {
	#name : 'OPBPMNAbstractFlowModel',
	#superclass : 'OPBPMNEdgeModel',
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'instance creation' }
OPBPMNAbstractFlowModel class >> from: aSource to: aTarget [
	^ self new
		source: aSource;
		target: aTarget;
		yourself
]

{ #category : 'accessing' }
OPBPMNAbstractFlowModel >> printIdType [
	^ '_6-'
]

{ #category : 'printing' }
OPBPMNAbstractFlowModel >> printType [
	^ self subclassResponsibility 
]
