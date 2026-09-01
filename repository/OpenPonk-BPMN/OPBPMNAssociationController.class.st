"
I manage the diagram interactions and connection rules for BPMN Associations, linking artifacts like text annotations to process elements.
"
Class {
	#name : 'OPBPMNAssociationController',
	#superclass : 'OPBPMNEdgeController',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPBPMNAssociationController class >> diagramElementClass [

	^ OPBPMNAssociationShape
]

{ #category : 'accessing' }
OPBPMNAssociationController class >> viewModelClass [
	^ OPBPMNAssociationViewModel
]
