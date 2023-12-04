CREATE TABLE Peers {
    Nickname TEXT NOT NULL PRIMARY KEY,
    Birthday DATE NOT NULL
}

CREATE TABLE Tasks {
    Title TEXT NOT NULL PRIMARY KEY,
    ParentTask TEXT,
    MaxXP BIGINT NOT NULL,
    FOREIGN KEY (ParentTask) REFERENCES Tasks (Title)
}

CREATE TYPE CheckStatus AS ENUM ('Start', 'Success', 'Failure');

CREATE TABLE P2P {
    ID BIGINT PRIMARY KEY NOT NULL,
    Check BIGINT NOT NULL,
    CheckingPeer varchar NOT NULL,
    State CheckStatus NOT NULL,
    Time time NOT NULL,
    FOREIGN KEY (Check) REFERENCES Checks (ID),
    FOREIGN KEY (CheckingPeer) REFERENCES Peers(Nickname)
}

CREATE TABLE TransferredPoints {
    ID BIGINT PRIMARY KEY NOT NULL,
    CheckingPeer TEXT NOT NULL,
    CheckedPeer TEXT NOT NULL,
    PointsAmount BIGINT NOT NULL,
    FOREIGN KEY (CheckingPeer) REFERENCES Peers(Nickname),
    FOREIGN KEY (CheckedPeer) REFERENCES Peers(Nickname)
}

CREATE TABLE Friends {
    ID BIGINT PRIMARY KEY NOT NULL,
    Peer1 TEXT NOT NULL,
    Peer2 TEXT NOT NULL,
    FOREIGN KEY (Peer1) REFERENCES Peers(Nickname),
    FOREIGN KEY (Peer2) REFERENCES Peers(Nickname)
}

CREATE TABLE Recommendations {
    ID BIGINT PRIMARY KEY NOT NULL,
    Peer TEXT NOT NULL,
    RecommendedPeer TEXT NOT NULL,
    FOREIGN KEY (Peer) REFERENCES Peers(Nickname),
    FOREIGN KEY (RecommendedPeer) REFERENCES Peers(Nickname)
}

CREATE TABLE TimeTracking {
    ID BIGINT PRIMARY KEY NOT NULL,
    Peer TEXT NOT NULL,
    Date DATE NOT NULL,
    Time TIME NOT NULL,
    State BIGINT NOT NULL CHECK (State IN (1, 2)),
    FOREIGN KEY (Peer) REFERENCES Peers(Nickname)
}

CREATE TABLE Checks {
    ID BIGINT PRIMARY KEY NOT NULL,
    Peer TEXT NOT NULL,
    Task TEXT NOT NULL,
    Date DATE NOT NULL,
    FOREIGN KEY (Peer) REFERENCES Peers (Nickname),
    FOREIGN KEY (Task) REFERENCES Tasks (Title)
}

CREATE TABLE Verter {
    ID BIGINT PRIMARY KEY NOT NULL,
    Check BIGINT NOT NULL,
    State CheckStatus NOT NULL,
    Time TIME NOT NULL,
    FOREIGN KEY (Check) REFERENCES Checks(ID)
}

CREATE TABLE XP {
    ID BIGINT PRIMARY KEY NOT NULL,
    Check BIGINT NOT NULL,
    XPAmount BIGINT NOT NULL,
    FOREIGN KEY (Check) REFERENCES Checks(ID)
}

