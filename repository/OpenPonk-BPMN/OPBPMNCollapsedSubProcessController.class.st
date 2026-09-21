"
I am the controller for collapsed BPMN SubProcesses. I manage canvas interactions and valid connections for sub-processes that hide their internal details.
"
Class {
	#name : 'OPBPMNCollapsedSubProcessController',
	#superclass : 'OPBPMNElementController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNCollapsedSubProcessController class >> diagramElementClass [

	^ OPBPMNCollapsedSubProcessShape
]

{ #category : 'accessing' }
OPBPMNCollapsedSubProcessController class >> viewModelClass [
	^ OPBPMNCollapsedSubProcessViewModel
]

{ #category : 'connecting' }
OPBPMNCollapsedSubProcessController >> canBeSourceFor: aController [

	^ aController isKindOf: OPBPMNEdgeController
]

{ #category : 'connecting' }
OPBPMNCollapsedSubProcessController >> canBeTargetFor: aController [
	(aController isKindOf: OPBPMNEdgeController) ifFalse: [ ^ false ].
	(aController isKindOf: OPBPMNMessageFlowController) ifTrue: [
		^ aController source model enclosingPool ~= self model enclosingPool and: [
			  aController source ~= self ] ].
	(aController isKindOf: OPBPMNDataFlowController) ifTrue: [
		^ (aController source model isKindOf: OPBPMNDataObjectModel) and: [
			  aController source ~= self ] ].
	^ aController source ~= self
]
