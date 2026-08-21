-- Resume AST Compiler: Hierarchical compilation with dependency edges
-- Haskell for algebraic data types & exhaustive validation

module Career.AST where

import Data.Text (Text)
import Data.Map.Strict (Map)
import Data.Set (Set)
import Data.Time (Day)
import GHC.Generics (Generic)
import Data.Aeson (ToJSON, FromJSON)
import Data.Hashable (Hashable)

data AstNode = AstNode
    { nodeId       :: NodeId
    , nodeType     :: NodeType
    , attributes   :: Map Text Text
    , children     :: [AstNode]
    , edges        :: [DependencyEdge]
    , verification :: VerificationStatus
    } deriving (Show, Eq, Generic)
instance ToJSON AstNode; instance FromJSON AstNode; instance Hashable AstNode

newtype NodeId = NodeId { unNodeId :: Text }
    deriving (Show, Eq, Ord, Generic, ToJSON, FromJSON, Hashable)

data NodeType
    = ProfessionalMilestone | TechnicalStack | LeadershipScope
    | QuantifiableImpact | DomainKeyword | EducationalCredential
    | ArtifactReference | SkillPrimitive
    deriving (Show, Eq, Generic, ToJSON, FromJSON, Hashable)

data DependencyEdge = DependencyEdge
    { fromNode :: NodeId, toNode :: NodeId, edgeType :: EdgeType, weight :: Double }
    deriving (Show, Eq, Generic, ToJSON, FromJSON, Hashable)

data EdgeType = Prerequisite | Progression | Composition | Transfer
    deriving (Show, Eq, Generic, ToJSON, FromJSON, Hashable)

data VerificationStatus = MachineChecked | HumanVerified | Unverified | Contradicted
    deriving (Show, Eq, Generic, ToJSON, FromJSON, Hashable)

data SkillPrimitive = SkillPrimitive
    { skillName      :: Text
    , skillCategory  :: SkillCategory
    , proficiency    :: ProficiencyLevel
    , evidenceNodes  :: Set NodeId
    , firstObserved  :: Day
    , lastReinforced :: Day
    } deriving (Show, Eq, Generic, ToJSON, FromJSON, Hashable)

data SkillCategory = Technical | Leadership | Domain | Communication | Analytical
    deriving (Show, Eq, Generic, ToJSON, FromJSON, Hashable)

data ProficiencyLevel = Novice | Practitioner | Expert | Authority
    deriving (Show, Eq, Ord, Generic, ToJSON, FromJSON, Hashable)

data ResumeAst = ResumeAst
    { astVersion      :: Int
    , rootNode        :: AstNode
    , nodeIndex       :: Map NodeId AstNode
    , edgeIndex       :: [DependencyEdge]
    , skillRegistry   :: Map Text SkillPrimitive
    , compilationHash :: Text
    } deriving (Show, Eq, Generic, ToJSON, FromJSON)

data Timeline = Timeline
    { segments :: [TimelineSegment], gaps :: [TimelineGap] }
    deriving (Show, Eq, Generic, ToJSON, FromJSON)

data TimelineSegment = TimelineSegment
    { segmentStart :: Day, segmentEnd :: Day
    , segmentNodes :: Set NodeId, segmentType :: SegmentType }
    deriving (Show, Eq, Generic, ToJSON, FromJSON)

data SegmentType = Employment | Education | Project | Gap | Transition
    deriving (Show, Eq, Generic, ToJSON, FromJSON)

data TimelineGap = TimelineGap
    { gapStart :: Day, gapEnd :: Day, gapReason :: Maybe Text, gapNodes :: Set NodeId }
    deriving (Show, Eq, Generic, ToJSON, FromJSON)

newtype CompileError = CompileError Text deriving (Show, Eq)

checkOrphanSkills :: [AstNode] -> Map Text SkillPrimitive -> Either CompileError ()
checkOrphanSkills _nodes _skills = Right ()

checkEdgeAcyclicity :: [AstNode] -> Either CompileError ()
checkEdgeAcyclicity _nodes = Right ()
