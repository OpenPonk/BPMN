Class {
	#name : 'OPBPMNAnnotationController',
	#superclass : 'OPBPMNNodeController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'connecting' }
OPBPMNAnnotationController >> canBeSourceFor: aController [

	^ aController isKindOf: OPBPMNAssociationController
]

{ #category : 'connecting' }
OPBPMNAnnotationController >> canBeTargetFor: aController [

	^ (aController isKindOf: OPBPMNAssociationController) and: [
		  aController source ~= self ]
]

{ #category : 'accessing' }
OPBPMNAnnotationController >> modelClass [

	^ OPBPMNAnnotationModel
]
