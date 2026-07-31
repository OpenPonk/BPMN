Class {
	#name : 'OPBPMNAssociationControllerTest',
	#superclass : 'OPBPMNEdgeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNAssociationControllerTest >> controllerClass [

	^ OPBPMNAssociationController
]

{ #category : 'constants' }
OPBPMNAssociationControllerTest >> diagramElementClass [

	^ OPBPMNAssociationShape
]

{ #category : 'constants' }
OPBPMNAssociationControllerTest >> modelClass [

	^ OPBPMNAssociationModel
]

{ #category : 'constants' }
OPBPMNAssociationControllerTest >> sourceControllerClass [

	^ OPBPMNActivityController
]

{ #category : 'constants' }
OPBPMNAssociationControllerTest >> sourceModelClass [

	^ OPBPMNActivityModel
]

{ #category : 'constants' }
OPBPMNAssociationControllerTest >> targetControllerClass [

	^ OPBPMNAnnotationController
]

{ #category : 'constants' }
OPBPMNAssociationControllerTest >> targetModelClass [

	^ OPBPMNAnnotationModel
]
