use std::fmt::Display;

use url::{ParseError, Url};

#[derive(Debug, PartialEq)]
pub enum UrlParseErr {
    InvalidFormat(ParseError),
    InvalidScheme,
    EmptyHost,
}

impl Display for UrlParseErr {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            UrlParseErr::EmptyHost => write!(f, "host are required"),
            UrlParseErr::InvalidScheme => write!(f, "scheme should be http or https"),
            UrlParseErr::InvalidFormat(e) => write!(f, "invalid format {}", e),
        }
    }
}

pub fn parse_url(url_str: &str) -> Result<Url, UrlParseErr> {
    let parsed_url = Url::parse(url_str).map_err(UrlParseErr::InvalidFormat)?;

    if !matches!(parsed_url.scheme(), "http" | "https") {
        return Err(UrlParseErr::InvalidScheme);
    }
    if parsed_url.host_str().is_none() {
        return Err(UrlParseErr::EmptyHost);
    }

    Ok(parsed_url)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_url_test() {
        assert_eq!(
            parse_url("https://example.com"),
            Ok(Url::parse("https://example.com").unwrap()),
        );
        assert_eq!(
            parse_url("http://localhost:8080"),
            Ok(Url::parse("http://localhost:8080").unwrap()),
        );
        assert_eq!(
            parse_url("hello"),
            Err(UrlParseErr::InvalidFormat(
                ParseError::RelativeUrlWithoutBase
            ))
        );
        assert_eq!(
            parse_url("mailto:user@example.com"),
            Err(UrlParseErr::InvalidScheme)
        );
    }
}
