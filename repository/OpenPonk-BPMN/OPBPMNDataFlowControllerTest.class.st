Class {
	#name : #OPBPMNDataFlowControllerTest,
	#superclass : #OPBPMNFlowControllerTest,
	#category : #'OpenPonk-BPMN-Tests'
}

{ #category : #accessing }
OPBPMNDataFlowControllerTest >> controllerClass [
	^ OPBPMNDataFlowController
]

{ #category : #accessing }
OPBPMNDataFlowControllerTest >> diagramElementClass [

	^ OPBPMNDataFlowShape 
]

{ #category : #accessing }
OPBPMNDataFlowControllerTest >> modelClass [
	^ OPBPMNDataFlowModel 
]

{ #category : #accessing }
OPBPMNDataFlowControllerTest >> targetControllerClass [
	^ OPBPMNDataObjectController  
]

{ #category : #accessing }
OPBPMNDataFlowControllerTest >> targetModelClass [
	^ OPBPMNDataObjectModel 
]

{ #category : #accessing }
OPBPMNDataFlowControllerTest >> testCreateFigure [

	| figure previousElementsSize |
	controller
		source: fromCtrl;
		target: toCtrl;
		model: model.
	diagramController addController: controller.
	previousElementsSize := diagramController canvas nodes size.
	figure := controller
		          createDiagramElement;
		          renderDiagramElement.
	self assert: figure class equals: OPRSPolyline.
	self assert: figure from equals: fromCtrl roassalShape.
	self assert: figure to equals: toCtrl roassalShape.
	self
		assert: diagramController canvas nodes size
		equals: previousElementsSize + self amountOfLabels.
	self assert: figure shape color equals: Color black.
	self assert: figure shape markerEnd isNil.
	self assert: figure shape markerStart isNil.
]
