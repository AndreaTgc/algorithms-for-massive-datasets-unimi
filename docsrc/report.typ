#import "style.typ": *

#show: paper.with(
  title : "Andrea Colombo - Algorithms for Massive Datasets course project - A.A 2025/2026",
  authors: ("Andrea Colombo",),
  abstract: [
    This report contains the documentation related to the project submission for the _Algorithms for Massive
    Datasets_ course. \
  ],
)

= Introduction

== Project Goals

The goal of this project is to provide an implementation for each presented algorithm that is correct and able to
scale to massive datasets without performance degradation (both in terms of memory and execution time).

== Development Environment

This project was developed using _Google Colab_ as the main computation environment. The Jupyter Notebook submitted alongside this project may require some modifications before being run in a local environment.

= Dataset Description

The dataset used for this project is the *New York Times Articles & Comments (2020)* @nyt_articles_comments dataset, freely
available and licensed under the *CC-BY-NC-SA-4.0* license. \

The datset, once downloaded, has a size of approximately *6.15 GBs* presents itself in the form of multiple files:

- *nyt-articles-2020.csv*: Contains all the articles published in 2020 by the NYT.
- *nyt-comments-2020.csv*: this file contains all the comments relative to the articles found in _nyt-articles-2020.csv_.
- *nyt-comments-part0.csv .. nyt-comments-part9.csv*: these fails simply contain the data found in _nyt-comments-2020.csv_ split
  in 10 different partitions.
- *test.csv*: Not relevant for our use case
- *train.csv*: Not relevant for our use case

== Preprocessing Techniques

During the preprocessing phase of the project we discarded all the columns that are not relevant for our use case, in particular:
- For the Flajolet-Martin portion of the project (@fm_algo), we discarded all the columns except the _UserID_ and, since all the
  fields inside the schema are tagged as *nullable*, we excluded all the null entries to avoid using garbage data.

== Subsampling

In order to ensure a reasonable execution time, we introduced a method that allows the user to load only a part of the dataset
instead of the whole.
This method can be tweaked by modifying the *SAMPLING_PROPORTION* (see: @sysconf) variable inside the notebook provided alongside this document. \

= System Configuration <sysconf>

The python notebook submitted with this project can be configured with the following set of variables:

- *ENABLE_LOGGING*: enables additional prints during the notebook execution
- *SAMPLING_PROPORTION*: How much of the whole dataset we want to use for the current run, valid if in range $(0, 1]$.
- *FM_NUM_HASHES*: Number of hash functions to use for the Flajolet-Martin implementation.

= Flajolet–Martin Algorithm <fm_algo>

First introduced in 1985 @flajolet1985probabilistic, the Flajolet-Martin algorithm is a probabilistic
algorithm that aims at estimating the number of distinct elements through the use of hash functions. \
The core idea is to leverage two very important properties of hash functions:

- *Determinism*: the hash function always maps the same value to the same result
- *Uniform Distribution*: the hashed values are uniformly distributed over the binary space

But why do we focus on the number of trailing zeros (tail length) of the hashed value? \
The probability that a single hash value ends with _n_ trailing zeros is $1/(2^n)$. \
From this forumula we can derive that:
- The probability of a single hash value not having _n_ trailing zeros is $1 - 1/2^n = 1 - 2^(-n)$
- The probability of *none* of _k_ hash values having _n_ trailing zeros is $(1 - 1/2^n)^k$. This can be
  approximated to $e^(-k 2^(-n))$ for very large numbers.

Therefore, if the maximum number of trailing zeros is $R_max$, it implies that we have seen approximatively
$2^(R_max)$ unique elements so far inside the stream.

== The Outlier Problem

Using a single hash function has one big issue, since we are taking the maximum number of trailing zeros
from a single source, we are susceptible to outliers.

The solution is simply using multiple hash functions and compute the median of their results. This has been verified
to provide more accurate results but it still has one problem, it always results in estimates that are power of 2. \
In order to fix this issue, we compute the average of the median estimations we just computed.

== Space/Time Complexity

This algorithm has a time complexity of $O(k n)$ where _n_ is the length of the stream and _k_ is the constant value
that refers to the computational cost of the hash functions and update procedure. \
The space complexity is $O(k)$ instead, we only need to store a constant amount of information needed to update the
trailing zeros counts; the precise memory usage depends on how many hash function we decide to use for the algorithm.

== Implementation Details

== Experimental Results

= AMS Algorithm

== Space/Time Complexity

== Implementation Details

== Experimental Results

= Conclusion

== Future Work

= Plagiarism and AI Usage Statement
\
_I declare that this material, which I now submit for assessment, is entirely my own work and has not been taken from the work of others, save and to the extent that such work has been cited and acknowledged within the text of my work. I understand that plagiarism, collusion, and copying are grave and serious offences in the university and accept the penalties that would be imposed should I engage in plagiarism, collusion or copying. This assignment, or any part of it, has not been previously submitted by me or any other person for assessment on this or any other course of study. No generative AI tool has been used to write the code or the report content._

#bibliography("bibliography.bib")
