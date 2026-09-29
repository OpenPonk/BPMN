"
I am the controller for BPMN Boundary Events. I manage the lifecycle and diagram interactions of events attached directly to the boundary of an activity.
"
Class {
	#name : 'OPBPMNBoundaryEventController',
	#superclass : 'OPBPMNElementController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNBoundaryEventController class >> diagramElementClass [

	^ OPBPMNBoundaryEventShape
]

{ #category : 'accessing' }
OPBPMNBoundaryEventController class >> viewModelClass [
	^ OPBPMNBoundaryEventViewModel
]

{ #category : 'connecting' }
OPBPMNBoundaryEventController >> canBeSourceFor: aController [

	^ (aController isKindOf: OPBPMNFlowController) or: [
		  aController isKindOf: OPBPMNAssociationController ]
]

{ #category : 'connecting' }
OPBPMNBoundaryEventController >> canBeTargetFor: aController [

	((aController isKindOf: OPBPMNMessageFlowController) or: [
		 aController isKindOf: OPBPMNAssociationController ]) ifFalse: [
		^ false ].

	(aController isKindOf: OPBPMNMessageFlowController) ifTrue: [
			aController source model enclosingPool = self model enclosingPool
				ifTrue: [ ^ false ] ].

	^ aController source ~= self
]

{ #category : 'construction' }
OPBPMNBoundaryEventController >> renderDiagramElement [
	| shape parentCtrl |
	shape := super renderDiagramElement.
	
	self model owner ifNil: [ ^ shape ].
	
	parentCtrl := self diagramController 
		controllerForModel: self model owner 
		ifNone: [ ^ shape ].
	
	RSLocation new
		bottom;
		right;
		offset: -1 @ 22;
		stick: shape
		on: parentCtrl roassalShape.
		
	parentCtrl roassalShape
		when: RSShapeRemovedEvent
		do: [ shape remove ]
		for: self.
		
	^ shape
]

{ #category : 'accessing' }
OPBPMNBoundaryEventController >> subscribeDiagram: aDiagram [

	self model subscribeDiagram: aDiagram
]
