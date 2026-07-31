Class {
	#name : 'OPBPMNDataObjectControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNDataObjectControllerTest >> controllerClass [
	^ OPBPMNDataObjectController  
]

{ #category : 'constants' }
OPBPMNDataObjectControllerTest >> creationTargetControllerClass [
	^ OPBPMNPoolController    
]

{ #category : 'constants' }
OPBPMNDataObjectControllerTest >> creationTargetModelClass [
	^ OPBPMNPoolModel 
]

{ #category : 'constants' }
OPBPMNDataObjectControllerTest >> diagramElementClass [
	^ OPBPMNDataObjectShape 
]

{ #category : 'constants' }
OPBPMNDataObjectControllerTest >> modelClass [
	^ OPBPMNDataObjectModel 
]
