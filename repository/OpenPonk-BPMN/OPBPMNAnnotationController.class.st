"
I control diagram interactions for BPMN Annotations, enforcing valid connection sources and targets on the canvas.
"
Class {
	#name : 'OPBPMNAnnotationController',
	#superclass : 'OPBPMNNodeController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNAnnotationController class >> diagramElementClass [

	^ OPBPMNAnnotationShape
]

{ #category : 'accessing' }
OPBPMNAnnotationController class >> viewModelClass [
	^ OPBPMNAnnotationViewModel
]

{ #category : 'connecting' }
OPBPMNAnnotationController >> canBeSourceFor: aController [

	^ aController isKindOf: OPBPMNAssociationController
]

{ #category : 'connecting' }
OPBPMNAnnotationController >> canBeTargetFor: aController [

	^ (aController isKindOf: OPBPMNAssociationController) and: [
		  aController source ~= self ]
]
