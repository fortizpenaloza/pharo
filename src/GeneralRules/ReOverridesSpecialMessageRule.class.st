"
Checks that a class does not override a message that is essential to the base system. For example, if you override the #class method from object, you are likely to crash your image. #classShouldNotOverride returns the list of messages which should not be overriden.
"
Class {
	#name : #ReOverridesSpecialMessageRule,
	#superclass : #ReAbstractRule,
	#category : #'GeneralRules-Migrated'
}

{ #category : #testing }
ReOverridesSpecialMessageRule class >> checksClass [
	^ true
]

{ #category : #accessing }
ReOverridesSpecialMessageRule class >> uniqueIdentifierName [
	"This number should be unique and should change only when the rule completely change semantics"
	
	^'OverridesSpecialMessageRule'
]

{ #category : #running }
ReOverridesSpecialMessageRule >> check: aClass forCritiquesDo: aCriticBlock [
	| selectors |
	selectors := aClass isMeta 
		ifTrue: [ self metaclassShouldNotOverride ]
		ifFalse: [ self classShouldNotOverride ].
	(selectors anySatisfy: [ :each |
		(aClass superclass notNil
			and: [ (aClass superclass canUnderstand: each)
			and: [ (aClass includesSelector: each) ] ]) ]) ifTrue: [ 
		aCriticBlock cull: (self critiqueFor: aClass) ]
]

{ #category : #private }
ReOverridesSpecialMessageRule >> classShouldNotOverride [
	^ #( #== #~~ #class #basicAt: #basicAt:put: #basicSize #identityHash )
]

{ #category : #accessing }
ReOverridesSpecialMessageRule >> group [
	^ 'Bugs'
]

{ #category : #private }
ReOverridesSpecialMessageRule >> metaclassShouldNotOverride [
	^ #( #basicNew #basicNew #class #comment #name )
]

{ #category : #accessing }
ReOverridesSpecialMessageRule >> name [
	^ 'Overrides a "special" message'
]

{ #category : #accessing }
ReOverridesSpecialMessageRule >> rationale [ 

	^ 'Checks that a class does not override a message that is essential to the base system. For example, if you override the #class method from object, you are likely to crash your image.
In the class the messages we should not override are: ',  (', ' join: (self classShouldNotOverride) ),'.
In the class side the messages we should not override are: ',  (', ' join: (self metaclassShouldNotOverride) ),'.'
]

{ #category : #accessing }
ReOverridesSpecialMessageRule >> severity [
	^ #error
]
