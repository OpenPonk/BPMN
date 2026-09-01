"
I am a specialized Roassal Control Point (CP) controller for BPMN Text Annotations. I manage routing and ensure that association lines visually connect appropriately to the open bracket of the annotation shape.
"
Class {
	#name : 'OPBPMNAnnotationCPController',
	#superclass : 'RSAbstractCPController',
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'hooks' }
OPBPMNAnnotationCPController >> controlPointsFor: aLine [

	| encompassingRectangle xPositions |
	encompassingRectangle := aLine from computeEncompassingRectangleFor:
		                         aLine from baseRectangle.

	xPositions := (self shouldBeOnRightBorderLine: aLine)
		              ifTrue: [
				              {
					              encompassingRectangle right.
					              (encompassingRectangle right
					               - aLine model visibleBorderWidth) } ]
		              ifFalse: [
				              {
					              encompassingRectangle left.
					              (encompassingRectangle left
					               + aLine model visibleBorderWidth) } ].

	^ Array
		  with: xPositions second @ encompassingRectangle top
		  with: xPositions first @ encompassingRectangle top
		  with: xPositions first @ encompassingRectangle bottom
		  with: xPositions second @ encompassingRectangle bottom
]

{ #category : 'hooks' }
OPBPMNAnnotationCPController >> goToAnnotationFromRight: twoPoints [

	^ twoPoints first x > twoPoints last x
]

{ #category : 'hooks' }
OPBPMNAnnotationCPController >> isLine: aRoassalLine connectedToRightHalfOf: aRoassalShape [

	aRoassalLine from = aRoassalShape ifTrue: [
			^ self goToAnnotationFromRight:
				  (aRoassalLine controlPoints first: 2) reversed ].

	aRoassalLine to = aRoassalShape ifTrue: [
		^ self goToAnnotationFromRight: (aRoassalLine controlPoints last: 2) ].

	self error: 'Roassal line is no longer connected'
]

{ #category : 'hooks' }
OPBPMNAnnotationCPController >> shouldBeOnRightBorderLine: aLine [

	| connectedLinesWithoutBorder |
	connectedLinesWithoutBorder := aLine from connectedLines
		                               copyWithout: aLine.

	^ connectedLinesWithoutBorder isNotEmpty and: [
			  connectedLinesWithoutBorder allSatisfy: [ :each |
				  self isLine: each connectedToRightHalfOf: aLine from ] ]
]
