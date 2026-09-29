"
I am the controller for BPMN SubProcesses. I manage diagram interactions, connection rules, and provide visual feedback when an invalid connection is attempted.
"
Class {
	#name : 'OPBPMNSubProcessController',
	#superclass : 'OPBPMNSemanticNodeController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNSubProcessController class >> diagramElementClass [

	^ OPBPMNSubProcessShape
]

{ #category : 'accessing' }
OPBPMNSubProcessController class >> viewModelClass [
	^ OPBPMNSubProcessViewModel
]

{ #category : 'connecting' }
OPBPMNSubProcessController >> canBeSourceFor: aController [

	^ aController isKindOf: OPBPMNEdgeController
]

{ #category : 'connecting' }
OPBPMNSubProcessController >> canBeTargetFor: aController [

	(aController isKindOf: OPBPMNElementController) ifTrue: [ ^ true ].

	(aController isKindOf: OPBPMNMessageFlowController) ifTrue: [
			aController source model enclosingPool = self model enclosingPool
				ifTrue: [ ^ false ] ].

	(aController isKindOf: OPBPMNDataFlowController) ifTrue: [
			(aController source model isKindOf: OPBPMNDataObjectModel)
				ifFalse: [ ^ false ] ].

	(aController isKindOf: OPBPMNEdgeController) ifFalse: [ ^ false ].

	^ aController source ~= self
]

{ #category : 'canvas actions' }
OPBPMNSubProcessController >> showDenyFeedbackFor: aController [

	^ nil
]
