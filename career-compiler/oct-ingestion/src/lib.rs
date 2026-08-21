// OCT Layer: Stream Normalization & Deterministic Chunking

use serde::{Deserialize, Serialize};
use std::collections::HashMap;

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct OctStream {
    pub version: u8,
    pub source_hash: String,
    pub tokens: Vec<OctToken>,
    pub metadata: OctMetadata,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct OctToken {
    pub id: u64,
    pub kind: TokenKind,
    pub span: Span,
    pub payload: TokenPayload,
    pub confidence: f32,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum TokenKind {
    Role, Skill, Metric, Milestone, Artifact, DateRange, Organization, DomainKeyword, StructuralMarker,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct Span { pub start: usize, pub end: usize, pub line: u32, pub column: u32 }

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct TokenPayload { pub raw: String, pub normalized: String, pub attributes: HashMap<String, String> }

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub struct OctMetadata {
    pub parser_version: String,
    pub timestamp_ns: u64,
    pub source_format: SourceFormat,
    pub chunk_count: usize,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
pub enum SourceFormat { Pdf, Docx, Markdown, Json, PlainText, Html }

pub struct OctIngestionEngine { pub config: IngestionConfig }

#[derive(Debug, Clone)]
pub struct IngestionConfig {
    pub max_token_span: usize,
    pub min_confidence: f32,
    pub enable_layout_analysis: bool,
    pub deterministic_chunking: bool,
}

impl Default for IngestionConfig {
    fn default() -> Self {
        Self { max_token_span: 512, min_confidence: 0.85, enable_layout_analysis: true, deterministic_chunking: true }
    }
}

impl OctIngestionEngine {
    pub fn new(config: IngestionConfig) -> Self { Self { config } }

    pub fn ingest(&self, raw: &[u8], format: SourceFormat) -> Result<OctStream, String> {
        let source_hash = blake3::hash(raw).to_hex().to_string();
        Ok(OctStream {
            version: 2,
            source_hash,
            tokens: vec![],
            metadata: OctMetadata {
                parser_version: env!("CARGO_PKG_VERSION").to_string(),
                timestamp_ns: std::time::SystemTime::now()
                    .duration_since(std::time::UNIX_EPOCH).unwrap().as_nanos() as u64,
                source_format: format,
                chunk_count: 0,
            },
        })
    }
}
