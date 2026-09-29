"
I am a unit test class verifying the creation, rendering, and interaction logic of OPBPMNDataObjectController.
"
Class {
	#name : 'OPBPMNDataObjectControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNDataObjectControllerTest class >> diagramElementClass [
	^ OPBPMNDataObjectShape 
]

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
OPBPMNDataObjectControllerTest >> modelClass [
	^ OPBPMNDataObjectModel 
]
