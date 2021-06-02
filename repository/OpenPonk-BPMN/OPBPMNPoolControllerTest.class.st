Class {
	#name : #OPBPMNPoolControllerTest,
	#superclass : #OPBPMNNodeControllerTest,
	#category : #'OpenPonk-BPMN-Tests'
}

{ #category : #accessing }
OPBPMNPoolControllerTest >> controllerClass [
	^ OPBPMNPoolController 
]

{ #category : #accessing }
OPBPMNPoolControllerTest >> modelClass [
	^ OPBPMNPoolModel 
]

{ #category : #accessing }
OPBPMNPoolControllerTest >> testFigureRefresh [
	| activityController group |
	controller createModelIn: diagramController model.
	diagramController addController: controller.
	controller renderFigureIn: diagramController view.
	
	activityController := OPBPMNActivityController new.
	activityController createModelIn: diagramController model.
	diagramController addController: activityController.
	
	activityController renderFigureIn: diagramController view.
	controller addedNodeFigure: activityController figure .
	controller refreshFigure.
	group := RTGroup new. group add: (activityController figure).
	self
		assert: (controller nodeFigures ) equals: group
		
]
