"
I control diagram interactions for BPMN Data Objects, managing connectivity rules and updating the type icon based on the object state.
"
Class {
	#name : 'OPBPMNDataObjectController',
	#superclass : 'OPBPMNSemanticNodeController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNDataObjectController class >> diagramElementClass [

	^ OPBPMNDataObjectShape
]

{ #category : 'accessing' }
OPBPMNDataObjectController class >> viewModelClass [
	^ OPBPMNDataObjectViewModel
]

{ #category : 'connecting' }
OPBPMNDataObjectController >> canBeSourceFor: aController [

	^ (aController isKindOf: OPBPMNDataFlowController) or: [
		  aController isKindOf: OPBPMNAssociationController ]
]

{ #category : 'connecting' }
OPBPMNDataObjectController >> canBeTargetFor: aController [
	((aController isKindOf: OPBPMNDataFlowController) or: [
		aController isKindOf: OPBPMNAssociationController ]) ifFalse: [ ^ false ].
	^ aController canConnectTo: self
]
