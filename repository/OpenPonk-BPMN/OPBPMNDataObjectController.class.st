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

	^ ((aController isKindOf: OPBPMNDataFlowController) or: [
		   aController isKindOf: OPBPMNAssociationController ]) and: [
		  aController source ~= self ]
]

{ #category : 'announcements' }
OPBPMNDataObjectController >> subscribeToViewModel [

	super subscribeToViewModel.
	self viewModel announcer weak
		when: OPBPMNPlaceTokensChanged
		send: #modelChanged
		to: self
]

{ #category : 'deprecation' }
OPBPMNDataObjectController >> typeIconFor: aType [
	self deprecated: 'Use viewModel instead' transformWith: '`@receiver typeIconFor: `@arg1' -> '`@receiver viewModel typeIconFor: `@arg1'.
	^ self viewModel typeIconFor: aType
]
