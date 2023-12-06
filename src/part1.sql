-- Peers table

DROP TABLE IF EXISTS Peer;

CREATE TABLE Peers {
    Nickname TEXT NOT NULL PRIMARY KEY,
    Birthday DATE NOT NULL
}

-- Tasks table

DROP TABLE IF EXISTS Tasks;

CREATE TABLE Tasks {
    Title TEXT NOT NULL PRIMARY KEY,
    ParentTask TEXT,
    MaxXP BIGINT NOT NULL,
    FOREIGN KEY (ParentTask) REFERENCES Tasks (Title)

-- CheckStatus Enum

DROP TYPE IF EXISTS CheckStatus;

CREATE TYPE CheckStatus AS ENUM ('Start', 'Success', 'Failure');

-- P2P table

DROP TABLE IF EXISTS P2P;

CREATE TABLE P2P {
    ID BIGINT PRIMARY KEY NOT NULL,
    Check BIGINT NOT NULL,
    CheckingPeer varchar NOT NULL,
    State CheckStatus NOT NULL,
    Time time NOT NULL,
    FOREIGN KEY (Check) REFERENCES Checks (ID),
    FOREIGN KEY (CheckingPeer) REFERENCES Peers(Nickname)
}

-- TransferredPoints table

DROP TABLE IF EXISTS TransferredPoints;

CREATE TABLE TransferredPoints {
    ID BIGINT PRIMARY KEY NOT NULL,
    CheckingPeer TEXT NOT NULL,
    CheckedPeer TEXT NOT NULL,
    PointsAmount BIGINT NOT NULL,
    FOREIGN KEY (CheckingPeer) REFERENCES Peers(Nickname),
    FOREIGN KEY (CheckedPeer) REFERENCES Peers(Nickname)
}

-- Friends table

DROP TABLE IF EXISTS Friends;

CREATE TABLE Friends {
    ID BIGINT PRIMARY KEY NOT NULL,
    Peer1 TEXT NOT NULL,
    Peer2 TEXT NOT NULL,
    FOREIGN KEY (Peer1) REFERENCES Peers(Nickname),
    FOREIGN KEY (Peer2) REFERENCES Peers(Nickname)
}

-- Recommendations table

DROP TABLE IF EXISTS Recommendations;

CREATE TABLE Recommendations {
    ID BIGINT PRIMARY KEY NOT NULL,
    Peer TEXT NOT NULL,
    RecommendedPeer TEXT NOT NULL,
    FOREIGN KEY (Peer) REFERENCES Peers(Nickname),
    FOREIGN KEY (RecommendedPeer) REFERENCES Peers(Nickname)
}

-- TimeTracking table

DROP TABLE IF EXISTS TimeTracking;

CREATE TABLE TimeTracking {
    ID BIGINT PRIMARY KEY NOT NULL,
    Peer TEXT NOT NULL,
    Date DATE NOT NULL,
    Time TIME NOT NULL,
    State BIGINT NOT NULL CHECK (State IN (1, 2)),
    FOREIGN KEY (Peer) REFERENCES Peers(Nickname)
}

-- Checks table

DROP TABLE IF EXISTS Checks;

CREATE TABLE Checks {
    ID BIGINT PRIMARY KEY NOT NULL,
    Peer TEXT NOT NULL,
    Task TEXT NOT NULL,
    Date DATE NOT NULL,
    FOREIGN KEY (Peer) REFERENCES Peers (Nickname),
    FOREIGN KEY (Task) REFERENCES Tasks (Title)
}

-- Verter table

DROP TABLE IF EXISTS Verter;

CREATE TABLE Verter {
    ID BIGINT PRIMARY KEY NOT NULL,
    Check BIGINT NOT NULL,
    State CheckStatus NOT NULL,
    Time TIME NOT NULL,
    FOREIGN KEY (Check) REFERENCES Checks(ID)
}

-- XP table

DROP TABLE IF EXISTS XP;

CREATE TABLE XP {
    ID BIGINT PRIMARY KEY NOT NULL,
    Check BIGINT NOT NULL,
    XPAmount BIGINT NOT NULL,
    FOREIGN KEY (Check) REFERENCES Checks(ID)
}

-- CSV import/export scripts

-- Peers table scripts

CREATE OR REPLACE PROCEDURE import_peers(filename_in TEXT, delimiter_in VARCHAR(5)) 
LANGUAGE plpgsql AS
$$
    BEGIN 
        EXECUTE 'COPY Peers(Nickname, Birthday) FROM ''' || filename_in || ''' WITH CSV HEADER DELIMITER' || quote_literal(delimiter_in);
    END;
$$;

CREATE OR REPLACE PROCEDURE export_peers(filename_in VARCHAR, delimeter_in VARCHAR(5))
LANGUAGE plpgsql AS
$$
    BEGIN
        EXECUTE 'COPY (SELECT * FROM Peers) TO ''' || filename_in || ''' WITH CSV HEADER DELIMITER ' || quote_literal(delimeter_in);
    END;
$$;

-- Tasks table sripts 

CREATE OR REPLACE PROCEDURE import_tasks(filename_in VARCHAR, delimeter_in VARCHAR(5))
LANGUAGE plpgsql AS
$$
    BEGIN
        EXECUTE 'COPY Tasks(Title, ParentTask, MaxXP) FROM ''' || filename_in || ''' WITH CSV HEADER DELIMITER ' || quote_literal(delimeter_in);
    END;
$$;


CREATE OR REPLACE PROCEDURE export_tasks(filename_in VARCHAR, delimeter_in VARCHAR(5))
LANGUAGE plpgsql AS
$$
    BEGIN
        EXECUTE 'COPY (SELECT * FROM Tasks) TO ''' || filename_in || ''' WITH CSV HEADER DELIMITER ' || quote_literal(delimeter_in);
    END;
$$;

-- P2P table sripts

CREATE OR REPLACE PROCEDURE import_p2p(filename_in VARCHAR, delimeter_in VARCHAR(5))
LANGUAGE plpgsql AS
$$
    BEGIN
        EXECUTE 'COPY P2P(ID, "Check", CheckingPeer, State, Time) FROM ''' || filename_in || ''' WITH CSV HEADER DELIMITER ' || quote_literal(delimeter_in);
        PERFORM setval('p2p_id_seq', (SELECT MAX(id) FROM P2P) + 1);
    END;
$$;

CREATE OR REPLACE PROCEDURE export_p2p(filename_in VARCHAR, delimeter_in VARCHAR(5))
LANGUAGE plpgsql AS
$$
    BEGIN
        EXECUTE 'COPY (SELECT * FROM P2P) TO ''' || filename_in || ''' WITH CSV HEADER DELIMITER ' || quote_literal(delimeter_in);
    END;
$$;

-- TransferredPoints table scripts

CREATE OR REPLACE PROCEDURE import_transferred_points(filename_in VARCHAR, delimeter_in VARCHAR(5))
    LANGUAGE plpgsql AS
$$
BEGIN
    EXECUTE 'COPY TransferredPoints(ID, CheckingPeer, CheckedPeer, PointsAmount) FROM ''' || filename_in ||
            ''' WITH CSV HEADER DELIMITER ' || quote_literal(delimeter_in);
    PERFORM setval('transferredpoints_id_seq', (SELECT MAX(ID) FROM TransferredPoints) + 1);
END;
$$;

CREATE OR REPLACE PROCEDURE export_transferred_points(filename_in VARCHAR, delimeter_in VARCHAR(5))
LANGUAGE plpgsql AS
$$
    BEGIN
        EXECUTE 'COPY (SELECT * FROM TransferredPoints) TO ''' || filename_in || ''' WITH CSV HEADER DELIMITER ' || quote_literal(delimeter_in);
    END;
$$;

-- Friends table scripts 

CREATE OR REPLACE PROCEDURE import_friends(filename_in VARCHAR, delimeter_in VARCHAR(5))
LANGUAGE plpgsql AS
$$
    BEGIN
        EXECUTE 'COPY Friends(ID, Peer1, Peer2) FROM ''' || filename_in || ''' WITH CSV HEADER DELIMITER ' || quote_literal(delimeter_in);
        PERFORM setval('friends_id_seq', (SELECT MAX(ID) FROM Friends) + 1);
    END;
$$;

CREATE OR REPLACE PROCEDURE export_friends(filename_in VARCHAR, delimeter_in VARCHAR(5))
LANGUAGE plpgsql AS
$$
    BEGIN
        EXECUTE 'COPY (SELECT * FROM Friends) TO ''' || filename_in || ''' WITH CSV HEADER DELIMITER ' || quote_literal(delimeter_in);
    END;
$$;

-- Recommendations table scripts

CREATE OR REPLACE PROCEDURE import_recommendations(filename_in VARCHAR, delimeter_in VARCHAR(5))
LANGUAGE plpgsql AS
$$
    BEGIN
        EXECUTE 'COPY Recommendations(ID, Peer, RecommendedPeer) FROM ''' || filename_in || ''' WITH CSV HEADER DELIMITER ' || quote_literal(delimeter_in);
        PERFORM setval('recommendations_id_seq', (SELECT MAX(ID) FROM Recommendations) + 1);
    END;
$$;

CREATE OR REPLACE PROCEDURE export_recommendations(filename_in VARCHAR, delimeter_in VARCHAR(5))
LANGUAGE plpgsql AS
$$
    BEGIN
        EXECUTE 'COPY (SELECT * FROM Recommendations) TO ''' || filename_in || ''' WITH CSV HEADER DELIMITER ' || quote_literal(delimeter_in);
    END;
$$;

-- TimeTracking table scripts

CREATE OR REPLACE PROCEDURE import_time_tracking(filename VARCHAR, delimiter VARCHAR(1))
LANGUAGE plpgsql AS
$$
    BEGIN
        EXECUTE 'COPY TimeTracking(ID, Peer, "Date", Time, State) FROM ''' || filename || ''' WITH CSV HEADER DELIMITER ' || quote_literal(delimiter);
        PERFORM setval('timetracking_id_seq', (SELECT MAX(id) FROM timetracking)+1);
    END;
$$;

CREATE OR REPLACE PROCEDURE export_time_tracking(filename VARCHAR, delimiter VARCHAR(5))
LANGUAGE plpgsql AS
$$
    BEGIN
        EXECUTE 'COPY (SELECT * FROM TimeTracking) TO ''' || filename || ''' WITH CSV HEADER DELIMITER ' || quote_literal(delimiter);
    END;
$$;

-- Checks table scripts

CREATE OR REPLACE PROCEDURE import_checks(filename VARCHAR, delimiter VARCHAR(1))
LANGUAGE plpgsql AS
$$
    BEGIN
        EXECUTE 'COPY Checks(ID, Peer, Task, "Date") FROM ''' || filename || ''' WITH CSV HEADER DELIMITER ' || quote_literal(delimiter);
        PERFORM setval('checks_id_seq', (SELECT MAX(id) FROM checks)+1);
    END;
$$;

CREATE OR REPLACE PROCEDURE export_checks(filename VARCHAR, delimiter VARCHAR(5))
LANGUAGE plpgsql AS
$$
    BEGIN
        EXECUTE 'COPY (SELECT * FROM Checks) TO ''' || filename || ''' WITH CSV HEADER DELIMITER ' || quote_literal(delimiter);
    END;
$$;

-- Verter table scripts

CREATE OR REPLACE PROCEDURE import_verter(filename VARCHAR, delimiter VARCHAR(1))
LANGUAGE plpgsql AS
$$
    BEGIN
        EXECUTE 'COPY Verter(ID, "Check", State, Time) FROM ''' || filename || ''' WITH CSV HEADER DELIMITER ' || quote_literal(delimiter);
        PERFORM setval('verter_id_seq', (SELECT MAX(id) FROM verter)+1);
    END;
$$;

CREATE OR REPLACE PROCEDURE export_verter(filename VARCHAR, delimiter VARCHAR(5))
LANGUAGE plpgsql AS
$$
    BEGIN
        EXECUTE 'COPY (SELECT * FROM Verter) TO ''' || filename || ''' WITH CSV HEADER DELIMITER ' || quote_literal(delimiter);
    END;
$$;

-- XP table scripts

CREATE OR REPLACE PROCEDURE import_xp(filename VARCHAR, delimiter VARCHAR(1))
LANGUAGE plpgsql AS
$$
    BEGIN
        EXECUTE 'COPY XP(ID, "Check", XPAmount) FROM ''' || filename || ''' WITH CSV HEADER DELIMITER ' || quote_literal(delimiter);
        PERFORM setval('xp_id_seq', (SELECT MAX(id) FROM xp)+1);
    END;
$$;

CREATE OR REPLACE PROCEDURE export_xp(filename VARCHAR, delimiter VARCHAR(5))
LANGUAGE plpgsql AS
$$
    BEGIN
        EXECUTE 'COPY (SELECT * FROM XP) TO ''' || filename || ''' WITH CSV HEADER DELIMITER ' || quote_literal(delimiter);
    END;
$$;

-- Fill tables calls

