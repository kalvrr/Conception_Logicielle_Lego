
-- Tables utilisateur (initialement vides)

CREATE SEQUENCE IF NOT EXISTS users_id_seq;

CREATE TABLE IF NOT EXISTS users (
    id_user INTEGER PRIMARY KEY DEFAULT nextval('users_id_seq'),
    username VARCHAR(20),
    hashed_password VARCHAR(255),
    salt VARCHAR(256)
);

CREATE TABLE IF NOT EXISTS favorite_sets (
    id_user INTEGER,
    set_num VARCHAR(20),
    FOREIGN KEY (id_user) REFERENCES users(id_user),
    FOREIGN KEY (set_num) REFERENCES sets(set_num),
    PRIMARY KEY (id_user, set_num)
);

-- Table des wishlists table maman <3 (une par utilisateur)
CREATE TABLE IF NOT EXISTS wishlist (
    id_wishlist INTEGER PRIMARY KEY,
    id_user INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_user) REFERENCES users(id_user) ON DELETE CASCADE,
    UNIQUE(id_user)  -- Un utilisateur = une wishlist
);

-- Table des pièces dans la wishlist
CREATE TABLE IF NOT EXISTS wishlist_parts (
    id_wishlist INTEGER NOT NULL,
    part_num VARCHAR(20) NOT NULL,
    color_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_wishlist, part_num, color_id),
    FOREIGN KEY (id_wishlist) REFERENCES wishlist(id_wishlist) ON DELETE CASCADE,
    FOREIGN KEY (part_num) REFERENCES parts(part_num) ON DELETE CASCADE,
    FOREIGN KEY (color_id) REFERENCES colors(id) ON DELETE CASCADE
);

-- Table des sets dans la wishlist
CREATE TABLE IF NOT EXISTS wishlist_sets (
    id_wishlist INTEGER NOT NULL,
    set_num VARCHAR(20) NOT NULL,
    priority INTEGER DEFAULT 0,  -- Pour ordonner les sets par priorité
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_wishlist, set_num),
    FOREIGN KEY (id_wishlist) REFERENCES wishlist(id_wishlist) ON DELETE CASCADE,
    FOREIGN KEY (set_num) REFERENCES sets(set_num) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS user_owned_sets (
    id_user INTEGER,
    set_num VARCHAR(20),
    is_built BOOLEAN,
    FOREIGN KEY (id_user) REFERENCES users(id_user),
    FOREIGN KEY (set_num) REFERENCES sets(set_num),
    PRIMARY KEY (id_user, set_num)
);

CREATE TABLE IF NOT EXISTS user_parts (
    id_user INTEGER,
    part_num VARCHAR(20),
    status_owned_wished VARCHAR(20),
    is_used BOOLEAN,
    FOREIGN KEY (id_user) REFERENCES users(id_user),
    FOREIGN KEY (part_num) REFERENCES parts(part_num),
    PRIMARY KEY (id_user, part_num)
);



CREATE INDEX IF NOT EXISTS idx_favorite_sets_user ON favorite_sets(id_user);
CREATE INDEX IF NOT EXISTS idx_wishlist_user ON wishlist(id_user);
CREATE INDEX IF NOT EXISTS idx_wishlist_parts_wishlist ON wishlist_parts(id_wishlist);
CREATE INDEX IF NOT EXISTS idx_wishlist_sets_wishlist ON wishlist_sets(id_wishlist);
CREATE INDEX IF NOT EXISTS idx_wishlist_parts_part ON wishlist_parts(part_num, color_id);
CREATE INDEX IF NOT EXISTS idx_user_parts_part ON user_parts(part_num, color_id);
CREATE INDEX IF NOT EXISTS idx_user_owned_sets_set ON user_owned_sets(set_num);
CREATE INDEX IF NOT EXISTS idx_user_owned_sets_user ON user_owned_sets(id_user);
CREATE INDEX IF NOT EXISTS idx_user_parts_user ON user_parts(id_user);